# CSSocketDemo
SocketDemo[博客](http://www.jianshu.com/p/cc756016243b)

#简介
该篇文章主要回顾--TCP/IP协议族中的TCP／UDP、HTTP；还有Socket。***（－－该文很干，酝酿了许久！你能耐心看完吗？O_o）***

我在这个[文章](http://www.jianshu.com/p/4b9d43c0571a)中，列举了常见的TCP/IP族中的协议，今天主角是－－传输层协议。

传输层（Transport Layer）是OSI（[七层模型](http://www.jianshu.com/p/4b9d43c0571a))中最重要、最关键的一层,它负责总体的数据传输和数据控制的一层，传输层提供端到端（应用会在网卡注册一个端口号）的交换数据的机制，检查分组编号与次序。传输层对其上三层如会话层等，提供可靠的传输服务，对网络层提供可靠的目的地站点信息。

#传输层中的协议

- 传输层它为应用层提供会话和数据报通信服务。
- 传输层承担OSI传输层的职责。
- 传输层的核心协议是TCP和UDP。
>TCP提供一对一的、面向连接的可靠通信服务。TCP建立连接，对发送的数据包进行排序和确认，并恢复在传输过程中丢失的数据包。与TCP不同，UDP提供一对一或一对多的、无连接的不可靠通信服务。
不论是TCP/IP还是在OSI参考模型中，任意相邻两层的下层为服务提供者，上层为服务调用者。下层为上层提供的服务可分为两类：面向连接服务和无连接服务。
1. 面向连接的网络服务
> 面向连接的网络服务又称为虚电路（Virtual Circuit）服务，它具有网络连接建立、数据传输和网络连接释放三个阶段。是按顺序传输可靠的报文分组方式，适用于指定对象、长报文、会话型传输要求。
> 面向连接服务以电话系统为模式。要和某个人通话，首先拿起电话，拨号码，通话，然后挂断。同样在使用面向连接的服务时，用户首先要建立连接，使用连接，然后释放连接。连接本质上像个管道：发送者在管道的一端放入物体，接收者在另一端按同样的次序取出物体；其特点是收发的数据不仅顺序一致，而且内容也相同。**--类似打电话**
2. 无连接的网络服务
> 无连接网络服务的两实体之间的通信不需要事先建立好一个连接。无连接网络服务有3种类型：数据报（Datagram）、确认交付（Confirmed Delivery）与请求回答（Request reply）。
无连接服务以邮政系统为模式。每个报文（信件）带有完整的目的地址，并且每一个报文都独立于其他报文，由系统选定的路线传递。在正常情况下，当两个报文发往同一目的地时，先发的先到。但是，也有可能先发的报文在途中延误了，后发的报文反而先收到；而这种情况在面向连接的服务中是绝对不可能发生的。**--类似发短信**

##传输控制协议（TCP）
1. TCP全称是Transmission Control Protocol，中文名为传输控制协议，它可以提供可靠的、面向连接的网络数据传递服务。传输控制协议主要包含下列任务和功能：
- 确保IP数据报的成功传递。
	- 对程序发送的大块数据进行分段和重组。
	- 确保正确排序及按顺序传递分段的数据。
	- 通过计算校验和，进行传输数据的完整性检查。
	- 根据数据是否接收成功发送肯定消息。通过使用选择性确认，也对没有收到的数据发送否定确认。
	为必须使用可靠的、基于会话的数据传输程序，如客户端/服务器数据库和电子邮件程序，提供首选传输方法。
2. TCP工作原理
TCP的连接建立过程又称为TCP*三次握手*;
  - 首先发送方主机向接收方主机发起一个建立连接的同步（SYN）请求；
 - 接收方主机在收到这个请求后向发送方主机回复一个同步/确认（SYN/ACK）应答；
 - 发送方主机收到此包后再向接收方主机发送一个确认（ACK），此时TCP连接成功建立.
  一旦初始的三次握手完成，在发送和接收主机之间将按顺序发送和确认段。关闭连接之前，TCP使用类似的握手过程验证两个主机是否都完成发送和接收全部数据。
完成三次握手，客户端与服务器开始传送数据。

三次握手示意图：
![三次握手.png](http://upload-images.jianshu.io/upload_images/1156719-c5842e3714145b94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

TCP工作过程比较复杂，包括的内容如下。
- TCP连接关闭：发送方主机和目的主机建立TCP连接并完成数据传输后，会发送一个将结束标记置1的数据包，以关闭这个TCP连接，并同时释放该连接占用的缓冲区空间。
- TCP重置：TCP允许在传输的过程中突然中断连接。
- TCP数据排序和确认*：在传输的过程中使用序列号和确认号来跟踪数据的接收情况。
- TCP重传：在TCP的传输过程中，如果在重传超时时间内没有收到接收方主机对某数据包的确认回复，发送方主机就认为此数据包丢失，并再次发送这个数据包给接收方。
- TCP延迟确认：TCP并不总是在接收到数据后立即对其进行确认，它允许主机在接收数据的同时发送自己的确认信息给对方。
- TCP数据保护（校验）：TCP是可靠传输的协议，它提供校验和计算来实现数据在传输过程中的完整性。

## 用户数据报协议（UDP）
> UDP全称是User Datagram Protocol，中文名为用户数据报协议。UDP 提供无连接的网络服务，该服务对消息中传输的数据提供不可靠的、最大努力传送。这意味着它不保证数据报的到达，也不保证所传送数据包的顺序是否正确。
我最初就有一个疑惑：“既然UDP是一种不可靠的网络协议，那么还有什么使用价值或必要呢？”
在有些情况下UDP可能会变得非常有用。因为UDP具有TCP所望尘莫及的速度优势。虽然TCP中植入了各种安全保障功能，但是在实际执行的过程中会占用大量的系统开销，无疑使速度受到严重的影响。反观UDP由于排除了信息可靠传递机制，将安全和排序等功能移交给上层应用来完成，极大地降低了执行时间，使速度得到了保证。

##TCP与端口号
> TCP和UDP都是IP层面的传输协议，是IP与上层之间的处理接口。TCP和UDP端口号被设计来区分运行在单个设备上的多重应用程序的IP地址。由于同一台计算机上可能会运行多个网络应用程序，所以计算机需要确保目标计算机上接收源主机数据包的软件应用程序的正确性，以及响应能够被发送到源主机的正确应用程序上。该过程正是通过使用TCP或UDP端口号来实现的。
***－－即每一个应用都会在网卡上注册一个端口号用来区分同一台设备上应用的之间的通信***

> 在TCP和UDP头部分，有“源端口”和“目标端口”段，主要用于显示发送和接收过程中的身份识别信息。IP 地址和端口号合在一起被称为“套接字”。TCP端口比较复杂，其工作方式与UDP端口不同。UDP端口对于基于UDP的通信作为单一消息队列和网络端点来操作，而所有TCP通信的终点都是唯一的连接。每个TCP连接由两个端点唯一识别。由于所有TCP连接由两对 IP 地址和TCP端口唯一识别（每个所连主机都有一个地址/端口对），因此每个TCP服务器端口都能提供对多个连接的共享访问
***再看一下IP数据包和TCP／UDP的数据包***
> ![数据包.png](http://upload-images.jianshu.io/upload_images/1156719-749d23000ec36f87.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#HTTP协议
超文本传输协议（HTTP，HyperText Transfer Protocol)是互联网上应用最为广泛的一种网络协议。
http协议规定了客户端和服务器之间的数据传输格式.
- http优点:
>简单快速: 
http协议简单,通信速度很快; 
灵活: 
http协议允许传输任意类型的数据;    
短连接:
http协议限制每次连接只处理一个请求,服务器对客户端的请求作出响应后,马上断开连接.这种方式可以节省传输时间.

##http协议的使用
1. 请求:客户端向服务器索要数据.
http协议规定:一个完整的http请求包含'请求行','请求头','请求体'三个部分;

  - 请求行：包含了请求方法,请求资源路径,http协议版本.  "GET /resources/images/ HTTP/1.1"              
  - 请求头:包含了对客户端的环境描述,客户端请求的主机地址等信息.               
>Accept: text/html ( 客户端所能接收的数据类型 )
Accept-Language: zh-cn  ( 客户端的语言环境  )
Accept-Encoding: gzip( 客户端支持的数据压缩格式  )
Host: m.baidu.com( 客户端想访问的服务器主机地址  ) 
User-Agent: Mozilla/5.0(Macintosh;Intel Mac OS X10.10  rv:37.0) Gecko/20100101Firefox/37.0( 客户端的类型,客户端的软件环境 )             
  - 请求体:客户端发给服务器的具体数据,比如文件/图片等.

2. 响应:服务器返回客户端想要的数据
http协议规定:一个完整的http响应包含'状态行','响应头','实体内容'三个部分;
 - 状态行:包含了http协议版本,状态吗,状态英文名称.
"HTTP/1.1 200 OK"
 - 响应头:包含了对服务器的描述,对返回数据的描述.
>Content-Encoding: gzip(服务器支持的数据压缩格式)       Content-Length: 1528(返回数据的长度)         
 Content-Type:application/xhtml+xml;charset=utf-8(返回数据的类型)     
Date: Mon,15Jun201509:06:46GMT(响应的时间)          Server: apache (服务器类型)               
 - 实体内容:服务器返回给客户端的具体数据(图片/html/文件...).

3. 发送http请求
 在iOS开发中,发送http请求的方案有很多,常见的有如下几种:        
 - 苹果原生:        
 >NSURLConnection:
用法简单,古老经典的一种方案.                
NSURLSession:
iOS7以后推出的技术,功能NSURLConnection更加强大.               
CFNetWork:NSURL的底层,纯C语言,一般不用.              
  - 第三方框架:  
 AFNetWorking（OC）；Alamofire（swift）；

###http方法
http协议定义了很多方法对应不同的资源操作,其中最常用的是GET和POST方法。
eg：GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT、PATCH  
增:PUT       
删:DELETE       
改:POST       
查:GET
因为GET和POST可以实现上述所有操作,所以,在现实开发中,GET和POST方法使用的最为广泛，除此以外HEAD请求使用频率也比较高；
- GET
>在请求URL后面以?的形式跟上发给服务器的参数,参数以"参数名"="参数值"的形式拼接,多个参数之间用&分隔;
GET的本质是从服务器得到数据,效率更高.并且GET请求可以被缓存.
注意:GET的长度是有限制的,不同的浏览器有不同的长度限制,一般在2~8K之间;
- POST
>POST的本质是向服务器发送数据,也可以获得服务器处理之后的结果,效率不如GET.POST请求不可以被缓存,每次刷新之后都需要重新提交表单.          
发送给服务器的参数全部放在'请求体'中;          
理论上,POST传递的数据量没有限制.          
注意:所有涉及到用户隐私的数据(密码/银行卡号等...)都要用POST的方式传递.
- HEAD
>HEAD方法通常用在下载文件之前,获取远程服务器的文件信息!相比于GET请求,不会下载文件数据,只获得响应头信息!      
一般,使用HEAD方法的目的是提前告诉用户下载文件的信息,由用户确定是否下载文件!所以, HEAD方法,最好发送同步请求!


###响应消息
1xx:信息响应类，表示接收到请求并且继续处理
2xx:处理成功响应类，表示动作被成功接收、理解和接受
3xx:[重定向](http://baike.baidu.com/view/1245190.htm)响应类，为了完成指定的动作，必须接受进一步处理
4xx:客户端错误，客户请求包含语法错误或者是不能正确执行
5xx:服务端错误，服务器不能正确执行一个正确的请求;
详细描述：[状态码](http://baike.baidu.com/link?url=3WXlrLc6tsB9rOD3rVwFoniTZLYTSKE2RErxcebexqoEWPs9aOBJKtcQaZNbiuIFSXKQa4EM1gSvk8EdF6Ei-gD0mW8dctgWNJLPa2tHGY4LmUoeTlO1BOgO_yMfBePPwq9MiCbz9oLPZs3cBPiN-GU6D8t_KQSjsUNz7QXQ8ZO)

#Socket
##Socket 简介
- Socket起源于 20 世 纪 80 年代早期,最早由 4.1c BSD UNIX 引入,所以也称之为“BSD Socket 或者 Berkeley Socket”。BSD Socket 是事实上的网络应用编程接口标准,其它编程语言往往也是用与这套（用C写成的编程接口）类似接口。
- 用 Socket 能够实现网络上的不同主机之间或同一主机的不同对象之间的数据通信。所以,现在 Socket 已经是一类通用通信接口的集合。
大的类型可以分为网络 Socket 和本地 Socket 两种。

###本地上的两个进程如何通信?
>- 内存共享(`munmap()`)；
- 消息和队列；
- 管道(匿名管道`pipe()`和命名管道`mkfifo()`)；
- 信号量（`P V`操作）;
- RPC  remote  protocol control
- 本地Socket;

###网路上的两个进程如何通信？
>本地进程间通信(IPC)通过PID(在终端中输入ps -ef可查看PID)可以唯一确定彼此，然后通过共享内存，消息队列来通;网络上的两个进程确定彼此需要IP与端口号，通过传输层(TCP/UDP)协议进行通信；
这就是网络 Socket 。
`socket可以理解为：在TCP/UDP 加一个端口(在网卡注册的，还记得吧)绑定。`

###网路socket和 本地 Socket对比
> - 在同一个设备上，两个进程如果需要进行通讯最基本的一个前提能能够唯一的标示一个进程，在本地进程通讯中可以使用PID来唯一标示一个进程；
- PID只在本地唯一，网络中的两个进程PID冲突几率很大，此时显然不行了，怎么办？
IP层的ip地址可以唯一标示主机，而TCP层协议和端口号可以唯一标示主机的一个进程，所以可以利用ip地址＋协议＋端口号唯一标示网络中的一个进程。

Socket通信就是一种确定了端口号的TCP/IP通信，或者说Socket通信与IP通信差别就是端口确定，协议确定。

用一张图表达一下：
![Socket.png](http://upload-images.jianshu.io/upload_images/1156719-5ab11b14ed460183.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

端口的打开是双方的，在C/S（Client&&Server）结构的TCP连接中不仅仅要注意到S的端口(监听的)，实际上C也开了一个端口，而C端的端口是动态端口，TCP连接建立的时候，C端的端口会在三次握手结束后确定，动态打开一个,这个端口不受用户/程序员的控制。

###Socket C 端书写步骤
1. 创建客户端Socket      
2. 创建服务器Socket        
3. 连接到服务器(Socket编程)   
4. 发送数据给服务器  
5. 接收服务器返回的数据  
6. 关闭Socket  : close(socketNumber)

一张经典的Socket C/S的步骤图。
![Socket.jpg](http://upload-images.jianshu.io/upload_images/1156719-f11be16e57524586.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
1.  导入头文件
#import <sys/socket.h> //socket相关
#import <netinet/in.h>  //internet相关
#import <arpa/inet.h>   //地址解析协议相关
2. socket(创建)
     int socket(int, int, int);
    /**
     参数
     第一个int：domain:    协议域，AF_INET（IPV4的网络开发）
     第二个int：type:      Socket 类型，  SOCK_STREAM(TCP)/SOCK_DGRAM(UDP，报文)
     第三个int：protocol:  IPPROTO_TCP，协议，如果输入0，可以根据第二个参数，自动选择协议
     返回值
     socket，如果 > 0 就表示成功
     */
3. connection (连接到“服务器)
    connect(int, const struct sockaddr *, socklen_t)
    /**
     参数
     1> 客户端socket
     2> 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
        服务器的"结构体"地址，C语言没有对象
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号
     */
4. write(发送数据)
    send(int, const void *, size_t, int)
    /**
     参数
     1> 客户端socket
     2> 发送内容地址 void * == id
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
      */
5. read (接收)
    recv(int, void *, size_t, int)
    /**
     参数
     第一个int :创建的socket
     void *：接收内容的地址
     size_t：接收内容的长度
     第二个int.：接收数据的标记 0，就是阻塞式，一直等待服务器的数据 
     返回值
     接收到的数据长度
     */
6. close
    close(int);
    int:就是创建的socket
```
按照上面5个步骤就可以写一个socket的通信的小demo：
写好的已经放在了我的[github](https://github.com/yscGit/CSSocketDemo)；
此时没有写服务端，怎么测试？
可利用：nc -lk 端口号:始终监听本地计算机此端口的数据。

eg：nc -lk 6666；
- 操作步骤gif
1. 监听 6666端口
2. connettion；
3. 发送`socket`；服务器接收到`socket`；
4. 服务端send ：hello socket；


![操作步骤.gif](http://upload-images.jianshu.io/upload_images/1156719-34b7d082f0b3617c.gif?imageMogr2/auto-orient/strip)

#### S端socket通信步骤
0. 提供一些服务
1. 将这个服务与自己的IP地址、端口绑定
2. 监听任何到这个IP+端口的TCP请求
3. 接受/拒绝建立这个TCP连接
4. 读写
5. 断开TCP连接

socket服务端下次再谈！
以上就是本次回顾。

---

[参考资料1](http://baike.baidu.com/link?url=KXln_rVFMKF5qTQzAG-e9GZVUzzldEsnptZvwyaTAZuwln46D3jWoZBNkdY-tRFRUcoYZRWYLwZQtLSTi8Tm5a)
[参考资料2](http://tieba.baidu.com/p/2670086104)
[参考资料3](http://www.cnblogs.com/skynet/archive/2010/12/12/1903949.html)
[参考资料4](http://goodcandle.cnblogs.com/archive/2005/12/10/294652.aspx)
[参考资料5](http://baike.baidu.com/link?url=3DHEDsszcKuO00VEKmnRK79wDpxnWfxsUHWCd4199p3yG8MMgiCOt1viuh8Geo4FM2Mhek6pr02gpDeY_S3peBgf6UcS_1voUw-gwg6BZeO)
