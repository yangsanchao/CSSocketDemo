//
//  ViewController.m
//  CSSocketDemo
//
//  Created by IMAC on 16/2/17.
//  Copyright © 2016年 ysc. All rights reserved.
//
#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UILabel *recvLabel;

///  client Socket
@property (nonatomic, assign) int clientSocket;
@end

@implementation ViewController

- (IBAction)connection {
    if ([self connection:self.hostText.text port:self.portText.text.intValue]) {
        self.recvLabel.text = @"connection success";
        NSLog( @"connection success");
    } else {
        self.recvLabel.text = @"connection error";
        NSLog( @"connection error");
    }
}

- (IBAction)send {
    if (self.messageText.text.length <= 0) {
        [self reminder];
        return;
    }
    self.recvLabel.text = [self sendAndRecv:self.messageText.text];
}

- (void)reminder {
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"send内容不能为空" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alerVC addAction:action];
    [self presentViewController:alerVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


// MARK: Socket
- (BOOL)connection:(NSString *)hostText port:(int)port {
    // socket
    /**
     参数
     domain:    协议域，AF_INET（IPV4的网络开发）
     type:      Socket 类型，SOCK_STREAM(TCP)/SOCK_DGRAM(UDP，报文)
     protocol:  IPPROTO_TCP，协议，如果输入0，可以根据第二个参数，自动选择协议
     
     返回值
     socket，如果 > 0 就表示成功
     */
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    if (self.clientSocket > 0) {
        NSLog(@"Socket Create success %d", self.clientSocket);
    } else {
        NSLog(@"Socket Create error");
    }
    
    //connection 连接到“服务器”
    /**
     参数
     1> 客户端socket
     2> 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     服务器的"结构体"地址，C语言没有对象
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号，非0即真
     */
    struct sockaddr_in serverAddress;
    // IPV4 - 协议
    serverAddress.sin_family = AF_INET;
    // inet_addr函数可以把ip地址转换成一个整数
    serverAddress.sin_addr.s_addr = inet_addr(hostText.UTF8String);
    // 端口小端存储
    serverAddress.sin_port = htons(port);
    
    int result = connect(self.clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    
    // 如果连接成功返回 YES
    return (result == 0);
}

///  发送和接收字符串
///  只跟 socket 打交道，和界面无关
- (NSString *)sendAndRecv:(NSString *)message {
    // send发送
    /**
     参数
     1> 客户端socket
     2> 发送内容地址 void * == id
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    
    ssize_t sendLen = send(self.clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
    NSLog(@"%ld", sendLen);
    
    // recv 接收 - 几乎所有的网络访问，都是有来有往的
    /**
     参数
     第一个int :创建的socket
     void *：接收内容的地址
     size_t：接收内容的长度
     第二个int.：接收数据的标记 0，就是阻塞式，一直等待服务器的数据
     返回值 接收到的数据长度
     */
    // unsigned char，字符串的数组
    uint8_t buffer[1024];
    
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    
    // 从buffer中读取服务器发回的数据
    // 按照服务器返回的长度，从 buffer 中，读取二进制数据，建立 NSData 对象
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

///  断开连接
- (void)disConnection {
    close(self.clientSocket);
}

@end
