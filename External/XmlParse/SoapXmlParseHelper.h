//
//  XmlParseHelper.h
//  HttpRequest
//
//  Created by Richard Liu on 13-3-18.
//  Copyright (c) 2013年 Richard Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface SoapXmlParseHelper : NSObject

//获取webservice调用返回的xml内容
+(NSString*)SoapMessageResultXml:(id)xml ServiceMethodName:(NSString*)methodName;

//xml转换成Array
+(NSMutableArray*)XmlToArray:(id)xml;

+(NSMutableArray*)nodeChilds:(GDataXMLNode*)node;

//判断xml是否为NSData或NSString
+(BOOL)isKindOfStringOrData:(id)xml;


@end
