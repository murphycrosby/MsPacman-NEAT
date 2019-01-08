//
//  WindowListAplierData.h
//  MsPacman-Neat
//
//  Created by Murphy Crosby on 1/5/19.
//  Copyright © 2019 Murphy Crosby. All rights reserved.
//

#ifndef WindowListAplierData_h
#define WindowListAplierData_h

@interface WindowListApplierData : NSObject
{
    
}
@property (strong, nonatomic) NSMutableArray * outputArray;
@property int order;

-(instancetype)initWindowListData:(NSMutableArray *)array;
void WindowListApplierFunction(const void *inputDictionary, void *context);

@end

#endif /* WindowListAplierData_h */
