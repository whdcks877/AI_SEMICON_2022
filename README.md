# TBPU(Tensor & Backpropagation Processing Unit)
2022 인공지능 반도체 설계대전 출품작  

# Modules  


## DataSetup  
Author : 박상민 
## MMU  (Matrix Multiply Module)
Author : 이준영 
## FullyConnected  
Author : 문종찬
### 1. 폴더 트리  
RTL\\* : 모듈 파일들  
SIM\TB\\* : 테스트 벤치 코드  

### 2. 모듈 구성   
1. **pe_1x128.sv** : 1x128 의 pe 묶음  
2. **FC_weight_buf.sv** : weight들이 저장된 buffer, 128개의 8bit x 84의 sram으로 구성되어있다.  
3. **ifmap_buf.sv** : input node가 저장된 buffer, 1개의 8bit x 128의 sram으로 구성되어있다.  
4. **fc_controller.sv** : buffer와 pe를 관리하는 controller 역할을 한다.  

### 3. TOP 모듈 설명 (**FullyConnected.sv**)  
- 외부로 부터 weight buffer와 ifmap_buffer를 쓰여지는 작업이 먼저 수행 되어야 한다.  
- 외부로 부터 입력 노드 개수(*in_node_num_i*)와 출력 노드 개수(*out_node_num_i*)를 입력 받고 시작신호(*start_i*)를 받으면 동작을 시작한다.  
- MAC연산을 수행하기 전에 입력 노드 개수(*in_node_num_i*)만큼 pe array에 입력 노드 값을 저장하는 과정이 필요한다.  
- 출력은 128번째 pe에서 출력되며 출력시 valid 신호를 보내며 마지막 출력 값에는 last신호를 함께 출력한다.  

### 4. TB 사용법 (tb_FullyConnected.sv)  
- 26번 줄을 통해 입력 노드의 개수를 설정할 수있다. <pre><code>int in_node_num = 120;</code></pre> 
- 27번 줄을 통해 출력 노드의 개수를 설정 할 수 있다.<pre><code>int out_node_num = 84;</code></pre> 
- 78번 줄을 통해서 입력 노드값을 생성한다.<pre><code>input_node[i] = $urandom_range(6,0)-3;</code></pre>
- 86번 줄을 통해서 입력되는 가중치 값을 생성한다. <pre><code>weight[i][j] = $urandom_range(6,0)-3;</code></pre>  

#### simulation 실행
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
## Accumulator  
Author : 문종찬
### 1. Accumulator.sv (단일 ACC 모듈)  
* Systolic array(MMU)의 16개의 출력중 하나로 부터 8bit 데이터를 받고 데이터 하나를 받을 때마다 valid-ready handshake를 거쳐서 입력 받는다.  
* 외부로부터 convolution 결과로 나오는 출력 데이터의 사이즈(*ofmap_size_i*)와 입력 데이터의 채널 사이즈 (*ifmap_ch_i*) 를 입력 받아야 한다.  
* 하나의 단일 모듈에는 32bit x 1024의 sram이 존재하고 이를 이용해서 값을 누적한다.
* 누적이 종료된후 activation 모듈로 8bit의 출력(*conv_result_o*)을 하나씩 내보낸다. 따라서 출력은 출력 데이터의 사이즈(*ofmap_size_i*)만큼의 사이클이 필요하다.  
* activatin 모듈이 출력될때에는 valid신호(*conv_valid_o*)를  출력하며 마지막 출력 값이 나올때에는 conv_last_o 신호를 출력한다.  

#### TB 설명(**TB_Accumulator.sv**)  

1. 맨위에 있는 `define 문에서 **CH_SIZE**와 **OFMAP_SIZE**로 입력 채널데이터와 출력 이미지의 사이즈를 정한다.
```
`define     CH_SIZE         16      //setting input channel size
`define     OFMAP_SIZE      784     //setting ouput feature map size
```
2. 54번줄을 이용해서 입력 데이터를 설정할 수있다.
```
psum_arr[i][j] = $urandom_range(255,0)-128; //-128 ~127
```

#### Simulation 방법
1. Vivado에 모듈과 테스트 벤치 코드를 넣고 시뮬레이션을 돌릴 수있다.
2. 커맨드 창을 이용한다.  
    1) cmd혹은 윈도우 터미널 창을 열고 /SIM 폴더로 이동한다.
    2) 다음 명령어를 순서대로 입력한다.
    ```
    xvlog --sv ..\SRC\TB_Accumulator.sv
    xelab -debug all -top TB_Accumulator -snapshot TB_Accumulator_snapshot
    ```

    3) xelab명령어를 통해 시뮬레이션이 준비가 되었다면 다음 명령어를 입력해서 시뮬레이션을 돌릴수 있다.
    ```
    xsim TB_Accumulator_snapshot -tclbatch xsim_cfg.tcl
    ```
    
    4) 시뮬레이션이 종료 된후 다음 명령어를 통해 gui창에서 waveform을 확인 할 수있다.
    ```
    xsim --gui TB_Accumulator_snapshot.wdb
    ```  

### 2. Accumulator_x16.sv (TOP)
*  단일 ACC 모듈을 단순히 16개를 묶어서 하나의 모듈로 만든것이다.
*  따라서 입출력 포트의 종류는 단일 모듈과 동일하지만 각각의 포트 마다 16개의 개별 포트가 존잰한다.

#### TB 설명 (**TB_Accumulator_x16.sv**)
단일 ACC모듈의 테스트 벤치와 동작은 동일하다. 
1. 맨위에 있는 define 문에서 CH_SIZE와 OFMAP_SIZE로 입력 채널데이터와 출력 이미지의 사이즈를 정한다.
2. 53번째 줄에 있는 psum_arr[i][j][k] = $urandom_range(255,0)-128;를 이용해서 입력 데이터를 설정할수 있다.  
#### Simulation 방법
1. Vivado에 모듈과 테스트 벤치 코드를 넣고 시뮬레이션을 돌릴 수있다
2. 커맨드 창을 이용할 수있다. 
    1) cmd혹은 윈도우 터미널 창을 열고 /SIM 폴더로 이동한다.
    2) 다음 명령어를 순서대로 입력한다.
    ```
    xvlog --sv ..\SRC\TB_Accumulator_x16.sv
    xelab -debug all -top TB_Accumulator_x16 -snapshot TB_Accumulator_x16_snapshot
    ```

    3) xelab명령어를 통해 시뮬레이션이 준비가 되었다면 다음 명령어를 입력해서 시뮬레이션을 돌릴수있다.
    ```
    xsim TB_Accumulator_x16_snapshot -tclbatch xsim_cfg.tcl
    ```

    4) 시뮬레이션이 종료 된후 다음 명령어를 통해 gui창에서 waveform을 확인 할 수있다.
    ```
    xsim --gui TB_Accumulator_x16_snapshot.wdb
    ```

## Activation  
Author : 임수혁  

## Pooling  
Author : 임수혁  

