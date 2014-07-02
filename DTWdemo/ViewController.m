//
//  ViewController.m
//  DTWdemo
//
//  Created by JYDMAC on 14-6-20.
//  Copyright (c) 2014年 zhoubo. All rights reserved.
//

#import "ViewController.h"
#import "NetWebServiceRequest.h"

@interface ViewController ()<NetWebServiceRequestDelegate>

@property (strong, nonatomic) NetWebServiceRequest* runningRequest;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询按钮
- (IBAction)queryBtn:(id)sender{
    if (_textField.text.length == 0) {
        return;
    }
    //封装soap请求消息
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                             "<SOAP-ENV:Envelope \n"
                             "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                             "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                             "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" \n"
                             "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"> \n"
                             "<SOAP-ENV:Body> \n"
                             
                             //======这里把 getMobileCodeInfo 换成 要条用的函数名 =====
                             "<getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\">\n"
                             
                             //这里把mobileCode、userID等,换成自己要提交的参数
                             "<mobileCode>%@</mobileCode>\n"
                             "<userID></userID>\n"
                             
                             "</getMobileCodeInfo>\n"
                             //=================
                             
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>",_textField.text];
    
    NSLog(@"%@",soapMessage);

    
    //请求发送到的路径
    NSString *url = @"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";//需要修改
    NSString *soapActionURL = @"http://WebXml.com.cn/getMobileCodeInfo";//需要修改
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:url SOAPActionURL:soapActionURL ServiceMethodName:@"getMobileCodeInfo" SoapMessage:soapMessage];//需要修改
    
    [request startAsynchronous];
    [request setDelegate:self];
    self.runningRequest = request;
}

#pragma mark NetWebServiceRequestDelegate Methods
//请求开始
- (void)netRequestStarted:(NetWebServiceRequest *)request
{
    NSLog(@"Start");
}

//请求完成
- (void)netRequestFinished:(NetWebServiceRequest *)request finishedInfoToResult:(NSString *)result responseData:(NSData *)requestData{
    NSLog(@"%@",result);
    _label.text = result;
}

//请求失败
- (void)netRequestFailed:(NetWebServiceRequest *)request didRequestError:(NSError *)error{
    NSLog(@"%@",error);
}

@end
