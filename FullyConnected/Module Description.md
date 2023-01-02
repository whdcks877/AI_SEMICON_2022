# Fully Connected

## 폴더 트리  
RTL\\* : 모듈 파일들  
SIM\TB\\* : 테스트 벤치 코드  

## 모듈 구성   
1. **pe_1x128.sv** : 1x128 의 pe 묶음  
2. **FC_weight_buf.sv** : weight들이 저장된 buffer, 128개의 8bit x 84의 sram으로 구성되어있다.  
3. **ifmap_buf.sv** : input node가 저장된 buffer, 1개의 8bit x 128의 sram으로 구성되어있다.  
4. **fc_controller.sv** : buffer와 pe를 관리하는 controller 역할을 한다.  

## TOP 모듈 설명 (**FullyConnected.sv**)  
- 외부로 부터 weight buffer와 ifmap_buffer를 쓰여지는 작업이 먼저 수행 되어야 한다.  
- 외부로 부터 입력 노드 개수(*in_node_num_i*)와 출력 노드 개수(*out_node_num_i*)를 입력 받고 시작신호(*start_i*)를 받으면 동작을 시작한다.  
- MAC연산을 수행하기 전에 입력 노드 개수(*in_node_num_i*)만큼 pe array에 입력 노드 값을 저장하는 과정이 필요한다.  
- 출력은 128번째 pe에서 출력되며 출력시 valid 신호를 보내며 마지막 출력 값에는 last신호를 함께 출력한다.  

## TB 사용법 (tb_FullyConnected.sv)  
- 26번 줄을 통해 입력 노드의 개수를 설정할 수있다. <pre><code>int in_node_num = 120;</code></pre> 
- 27번 줄을 통해 출력 노드의 개수를 설정 할 수 있다.<pre><code>int out_node_num = 84;</code></pre> 
- 78번 줄을 통해서 입력 노드값을 생성한다.<pre><code>input_node[i] = $urandom_range(6,0)-3;</code></pre>
- 86번 줄을 통해서 입력되는 가중치 값을 생성한다. <pre><code>weight[i][j] = $urandom_range(6,0)-3;</code></pre>  

### simulation 실행
1. Vivado로 프로젝트 생성후 tb_FullyConnected.sv를 TOP으로 설정후 시뮬레이션이 가능하다.  

2. 다음 방법으로 커맨드 창을 통해 시뮬레이션이 가능하다.  

    1) cmd혹은 윈도우 터미널을 열고 /SIM 폴더로 이동한다.
    ``` 
    cd .\SIM\ 
    ```
    2) SIM 폴더로 이동했다면 다음 명령어를 순서대로 입력한다.   
    ```
    xvlog --sv TB\tb_FullyConnected.sv
    xelab -debug all -top tb_FullyConnected -snapshot tb_FullyConnected_snapshot
    ```

    3) xelab명령어를 통해 시뮬레이션이 준비가 되었다면 다음 명령어를 입력해서 시뮬레이션을 수행할 수있다.
    ```
    xsim tb_FullyConnected_snapshot -tclbatch xsim_cfg.tcl
    ```

    4) 시뮬레이션이 종료 된후 다음 명령어를 통해 gui창에서 waveform을 확인 할 수있다.
    ```
    xsim --gui tb_FullyConnected_snapshot.wdb
    ```