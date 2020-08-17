---
title: "Computer Architecture"
excerpt: ""
use_math: true
categories:
 - computer science
last_modified_at: 2020-03-16T12:31:00
---

> [32bit와 64bit의 차이, 메모리와의 관계](#32bit와-64bit의-차이-메모리와의-관계)
>

---
# 32bit와 64bit의 차이, 메모리와의 관계
### CPU에서

32bit, 64bit CPU 는 각각 32bit, 64bit 크기의 레지스터, 주소 버스, 데이터 버스에 기반을 둔다. 일반적으로 CPU의 bit는 CPU가 처리하는 데이터의 최소 단위인 레지스터(Register)의 크기를 의미한다.

32bit 레지스터는 한 번에 32bit를 처리할 수 있고, 32bit로 표현할 수 있는 수의 최대값은 \\(2^{32}\\) 이다. 즉, 숫자 \\(4,294,967,296(= 2^{30} * 2^2 = 2^{32})\\) 까지 표현 가능하다.

따라서 32bit CPU가 어떠한 처리를 위해 메모리에 접근할 때, 4,294,967,296 까지의 메모리 주소를 인식할 수 있다. 즉, 표현 가능한 숫자의 최대값은 인식 가능한 메모리 주소의 최대 범위를 뜻한다.

메모리의 주소 공간은 1byte이기 때문에 이를 계산하면 32bit CPU가 인식할 수 있는 메모리의 최대 용량은 4GB가 된다.

$$
4,294,967,296=2^{32}=2^{30}*2^2=1GB*4=4GB
$$

같은 방식으로 계산했을 때 64bit CPU가 인식할 수 있는 메모리의 최대 용량은 16EB가 된다.

$$
18,446,744,073,709,551,616=2^{64}=2^{60}*2^4=1EB*16=16EB
$$



### 운영체제에서
32bit, 64bit CPU가 인식할 수 있는 메모리의 최대 용량은 각각 4GB, 16EB 이지만, 운영체제 마다 제한하는 메모리의 크기는 다르다.

Windows를 예로 들었을때, 32bit Windows의 경우 보통 4GB의 메모리 제한을 두지만 이 4GB 중 일부는 하드웨어 예약으로 사용된다. 물리적인 메모리 제한은 Windows 버전과 플랫폼에 따라 달라진다.

<img src="https://user-images.githubusercontent.com/19742979/55923624-30087100-5c41-11e9-81d9-7d2f6f5d040d.PNG" style="display:block; margin-left:auto; margin-right:auto"/>

Windows에서 각 프로세스에게 할당해주는 가상메모리 또한 제한을 갖는다. 32bit Windows의 경우 가상메모리는 2GB의 커널모드 주소 공간과 2GB의 유저모드 주소 공간으로 분할되는데, 프로세스가 실제 자유롭게 사용할 수 있는 영역은 2GB의 유저모드 파티션이다.

가상메모리의 제한은 Windows 버전과 플랫폼, 타겟 프로세스에 따라 달라진다. 

<img src="https://user-images.githubusercontent.com/19742979/55924447-ddc94f00-5c44-11e9-9100-31461fd93b49.PNG" style="display:block; margin-left:auto; margin-right:auto"/>

위와 같은 Windows의 사항들은 Windows Developer Center 에서 확인할 수 있다. [Memory Limit for Windows and Windows Server Releases](https://docs.microsoft.com/en-us/windows/desktop/memory/memory-limits-for-windows-releases)


#### 참고 
\\(1byte=8bit\\)  
\\(1KB=2^{10}byte\\)  
\\(1MB=2^{10}KB\\)  
\\(1GB=2^{10}MB\\)  
\\(1TB=2^{10}GB\\)  
\\(1PB=2^{10}TB\\)  
\\(1EB=2^{10}PB\\)  
