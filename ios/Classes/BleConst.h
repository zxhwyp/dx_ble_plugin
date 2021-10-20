//
//  BleConst.h
//  Runner
//
//  Created by 周小华 on 2021/10/13.
//

#ifndef BleConst_h
#define BleConst_h

//原生主动调用flutter方法
static NSString * const BLE_NAME = @"com.dx.bleplugin";

static NSString * const CALL_ERROR = @"errorCall";

static NSString * const CALL_STATUS = @"statusCall";

static NSString * const CALL_SEARCH = @"searchCall";

static NSString * const CALL_CONNECTLOCK = @"connectlockCall";

static NSString * const CALL_LOCKCODE = @"lockcodeCall";

static NSString * const CALL_OPENLOCK = @"openlockCall";


//flutter主动调用原生方法

static NSString * const METHOD_SEARCHBLE = @"searchBleList";

static NSString * const METHOD_CONNECTLOCK = @"connectlock";

static NSString * const METHOD_READLOCKCODE = @"readlockcode";

static NSString * const METHOD_OPENLOCK = @"openlock";

static NSString * const BLE_CL = @"ChuangLi";

static NSString * const BLE_RUIAO_Enhance = @"RuiAuEnhance";

static NSString * const BLE_RUIAO_Simple = @"RuiAuSimple";


#endif /* BleConst_h */

