//
//  XmlParseHelper.m
//  HttpRequest
//
//  Created by Richard Liu on 13-3-18.
//  Copyright (c) 2013年 Richard Liu. All rights reserved.
//

#import "SoapXmlParseHelper.h"
#import "GDataXMLNode.h"

@implementation SoapXmlParseHelper


//判断xml是否为NSData或NSString
+ (BOOL)isKindOfStringOrData:(id)xml{
    if ([xml isKindOfClass:[NSString class]]||[xml isKindOfClass:[NSData class]]) {
        return YES;
    }
    return NO;
}

//获取webservice调用返回的xml内容
+ (NSString*)SoapMessageResultXml:(id)data ServiceMethodName:(NSString*)methodName{
    
    if (![self isKindOfStringOrData:data]) {
        return @"";
    }
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([data isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    }else{
        document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }
    if (error) {
        [document release];
        return @"";
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSString *searchStr=[NSString stringWithFormat:@"%@Result",methodName];
    NSString *MsgResult=@"";
    NSArray *result=[rootNode children];
    while ([result count]>0) {
        NSString *nodeName=[[result objectAtIndex:0] name];
        if ([nodeName isEqualToString: searchStr]) {
            MsgResult=[[result objectAtIndex:0] stringValue];
            break;
        }
        result=[[result objectAtIndex:0] children];
    }
    [document release];
    return MsgResult;
}


//xml转换成Array
+ (NSMutableArray*)XmlToArray:(id)xml{
    NSMutableArray *arr=[NSMutableArray array];
    if (![self isKindOfStringOrData:xml]) {
        return arr;
    }
    NSError *error=nil;
    GDataXMLDocument *document;
    if ([xml isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
    }
    else
       document=[[GDataXMLDocument alloc] initWithData:xml options:0 error:&error];
    if (error) {
        [document release];
        return arr;
    }
    GDataXMLElement* rootNode = [document rootElement];
    NSArray *rootChilds=[rootNode children];
    for (GDataXMLNode *node in rootChilds) {
        NSString *nodeName=node.name;
        if ([node.children count]>0) {
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self nodeChilds:node],nodeName, nil]];
        }else{
            [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[node stringValue],nodeName, nil]];
        }
    }
    return arr;
}

+ (NSMutableArray*)nodeChilds:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *childs=[node children];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (GDataXMLNode* child in childs){
        NSString *nodeName=child.name;//获取节点名称
        NSArray  *childNode=[child children];
        if ([childNode count]>0) {//存在子节点
            [dic setValue:[self nodeChilds:child] forKey:nodeName];
        }else{
            [dic setValue:[child stringValue] forKey:nodeName];
        }
    }
    [arr addObject:dic];
    return arr;
}

@end
