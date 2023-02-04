설계 RTL 파일은 RTL 폴더 안에 있으며 TOP 모듈은 TOP_withDMA.sv 입니다.
테스트를 위한 파일은 reference 폴더에 있으며 시뮬레이션 시 함께 첨부해야 합니다.
테스트 벤치 코드는 TB_TOP_DMA.sv이며 시뮬레이션 실행시 10000개의 데이터 셋으로 모델을 평가합니다.
시뮬레이션 시 Timeout을 방지하기 위해 run all을 이용해서 실행하시면 진행하기 수월합니다.
ip_repo 폴더에는 FPGA에 구현하기 위해 설계한 AXI TPU controller ip가 포함되어 있습니다.