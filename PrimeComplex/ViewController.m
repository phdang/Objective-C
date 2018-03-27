//
//  ViewController.m
//  PrimeComplex
//
//  Created by HAI DANG on 3/26/18.
//  Copyright © 2018 HAI DANG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray *generalArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *starterArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *rsArr = [[NSMutableArray alloc]init];
    
    int sum = 13;
    
    int first = 3;

    [generalArr addObjectsFromArray:[self returnNumberWithSum:sum]];
    
    starterArr = [self returnStarterArrWithArray:generalArr firstValue:first];
    
    starterArr = [self filterArrayIn:starterArr];
    
    rsArr = [self returnRsArrWithStarterArr:starterArr generalArr:generalArr];
    
    if ([rsArr count])
        NSLog(@"Result array: %@", rsArr);
}

- (NSMutableArray *)returnNumberWithSum:(int)sum {
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    int count = 0;
    
    for (int i = 10000; i < 100000; i++) {
        
        if  (![self checkNumberPrimeNumber:i])
            continue;
        
        int temp = i;
        int add = 0;
        
        while(temp > 0) {
            
            int digit = temp%10;
            
            add += digit;
            
            if (add > sum)
                break;
        
            temp = temp/10;
        }
        
        if (add == sum) {
            
            [arr addObject:[NSNumber numberWithInt:i]];
            
            count++;
        }
        
    }
    
    return  arr;
}

-(BOOL)checkNumberPrimeNumber:(int)number{
    
    int i; BOOL flag=false;
    
    for (i=2; i<number/2; i++) {
        if (number%i==0) {
            flag=true;
            break;
        }
    }
    
    if (flag == true)
       
        return NO;
    
     else
         return YES;
}

- (int)numberStartsWith:(int)number withfirstValue:(int)first {
    
    int starter = ceil((float)(number / 10000));
    
    if (starter == first) {
        
        return number;
    }
    
    return 0;
}

- (NSMutableArray*)returnStarterArrWithArray:(NSMutableArray*)arr firstValue:(int)first {
    
    NSMutableArray *starterArr = [[NSMutableArray alloc]init];
    for (id number in arr) {
        
        
        int qualifiedNumbers = [self numberStartsWith:[number intValue] withfirstValue:first];
        
        if (qualifiedNumbers > 0) {
            
            [starterArr addObject:[NSNumber numberWithInt:qualifiedNumbers]];
        }
    }
    
    return starterArr;
}

- (NSMutableArray *)filterArrayIn:(NSMutableArray *)arr {
    
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
    for (id number in arr) {
        
        BOOL isFiltered = NO;
        
        for (int i = 0; i < 5; i++) {
            
            int digit = [self getDigitNumberWith:[number intValue] ditgitPlace:i+1];
            
            if (digit == 0)
                isFiltered = YES;
        }
        
        if (isFiltered)
            continue;
        [filterArr addObject:number];
    }
    
    return filterArr;
}

- (NSMutableArray *)filterArrayIn:(NSMutableArray *)arr endWith:(int)end {
    
    NSMutableArray *filterArr = [[NSMutableArray alloc]init];
    
    for (id number in arr) {
        
        BOOL isFiltered = YES;
        
        int digit = [self getDigitNumberWith:[number intValue] ditgitPlace:1];
        
        if (digit == end)
            isFiltered = NO;
        
        if (isFiltered)
            continue;
        [filterArr addObject:number];
    }
    
    return filterArr;
}

- (int)getDigitNumberWith:(int)number ditgitPlace:(int)theDigitPlace {
    
    int theNumber = number;
    
    int theDigit = (theNumber/(int)(pow(10, theDigitPlace - 1))) % 10;
    
    return theDigit;
}

- (NSMutableArray*)splitNumberIntoArrWith:(int)number {
    
    int temp = number;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    while(temp >0){
        
        int digit = temp%10;
        
        temp /= 10;
        
        [arr addObject: [NSNumber numberWithInt:digit]];
    }
    
    NSArray *revArr = [[arr reverseObjectEnumerator] allObjects];

    [arr removeAllObjects];
    
    [arr addObjectsFromArray:revArr];
    
    return  arr;
}

- (BOOL)isNumberStartWith:(NSString* )str inArr:(NSMutableArray*)arr {
    
    BOOL hasNumber = NO;
    
    for (id number in arr) {
        
        hasNumber = [[number stringValue] hasPrefix:str];
        
        if (hasNumber)
            break;
    }
    
    return hasNumber;
}

-(NSMutableArray*)returnRsArrWithStarterArr:(NSMutableArray*)starterArr generalArr:(NSMutableArray*)generalArr {
    
    int first = 0;
    
    NSMutableArray *rsArr = [[NSMutableArray alloc]init];
    
    NSMutableArray *rs4number = [[NSMutableArray alloc]init];
    
    for (id number in starterArr) {
        
        [rs4number removeAllObjects];
        
        for (int i = 0; i < 5; i++) {
            
            first = [self getDigitNumberWith:[number intValue] ditgitPlace:5-i];
            
            if (i == 0)
                
                [rs4number addObject: [self filterArrayIn:[self returnStarterArrWithArray:generalArr firstValue:first]]];
            else
                [rs4number addObject:[self returnStarterArrWithArray:generalArr firstValue:first]];
            
        }
        
        NSMutableArray *diag1Arr = [[NSMutableArray alloc]init];
        
        NSMutableArray *diag2Arr = [[NSMutableArray alloc]init];
        
        [diag1Arr removeAllObjects]; [diag2Arr removeAllObjects];
        
        int diag1First = [self getDigitNumberWith:[number intValue] ditgitPlace:5];
        
        diag1Arr = [self returnStarterArrWithArray:generalArr firstValue:diag1First];
        
        int diag2First = [self getDigitNumberWith:[number intValue] ditgitPlace:1];
        
        diag2Arr = [self returnStarterArrWithArray:generalArr firstValue:diag2First];
        
        int end = [self getDigitNumberWith:[number intValue] ditgitPlace:1];
        
        diag2Arr = [self filterArrayIn:diag2Arr endWith: end];
        
        for (id obj1 in rs4number[0]) {
            
            NSMutableArray *numArr1 = [[NSMutableArray alloc]init];
            
            [numArr1 removeAllObjects];
            
            numArr1 = [self splitNumberIntoArrWith:[obj1 intValue]];
            
            int pos11 = [[numArr1 objectAtIndex:0] intValue];
            
            if (pos11 != [self getDigitNumberWith:[number intValue] ditgitPlace:5])
                continue;
            
            int pos12 = [[numArr1 objectAtIndex:1] intValue];
            
            if (pos12 != [self getDigitNumberWith:[number intValue] ditgitPlace:4])
                continue;
            
            int pos13 = [[numArr1 objectAtIndex:2] intValue];
            
            if (pos13 != [self getDigitNumberWith:[number intValue] ditgitPlace:3])
                continue;
            
            int pos14 = [[numArr1 objectAtIndex:3] intValue];
            
            if (pos14 != [self getDigitNumberWith:[number intValue] ditgitPlace:2])
                continue;
            
            int pos15 = [[numArr1 objectAtIndex:4] intValue];
            
            if (pos15 != [self getDigitNumberWith:[number intValue] ditgitPlace:1])
                continue;
            
            for (id obj2 in rs4number[1]) {
                
                NSMutableArray *numArr2 = [[NSMutableArray alloc]init];
                
                [numArr2 removeAllObjects];
                
                numArr2 = [self splitNumberIntoArrWith:[obj2 intValue]];
                
                int pos22 = [[numArr2 objectAtIndex:1] intValue];
                
                int pos23 = [[numArr2 objectAtIndex:2] intValue];
                
                int pos24 = [[numArr2 objectAtIndex:3] intValue];
                
                int pos25 = [[numArr2 objectAtIndex:4] intValue];
                
                NSString *strObj21 = [NSString stringWithFormat:@"%d%d",pos11,pos22];
                
                NSString *col2 = [NSString stringWithFormat:@"%d%d",pos12,pos22];
                
                if (![self isNumberStartWith:col2 inArr:generalArr])
                    continue;
                
                NSString *col3 = [NSString stringWithFormat:@"%d%d",pos13,pos23];
                
                if (![self isNumberStartWith:col3 inArr:generalArr])
                    continue;
                
                NSString *col4 = [NSString stringWithFormat:@"%d%d",pos14,pos24];
                
                if (![self isNumberStartWith:col4 inArr:generalArr])
                    continue;
                
                NSString *col5 = [NSString stringWithFormat:@"%d%d",pos15,pos25];
                
                if (![self isNumberStartWith:col5 inArr:generalArr])
                    continue;
                
                if (![self isNumberStartWith:strObj21 inArr:diag1Arr])
                    continue;
                
                NSString *strObj22 = [NSString stringWithFormat:@"%d%d",pos15,pos24];
                
                if (![self isNumberStartWith:strObj22 inArr:diag2Arr])
                    continue;
                
                for (id obj3 in rs4number[2]) {
                    
                    NSMutableArray *numArr3 = [[NSMutableArray alloc]init];
                    
                    [numArr3 removeAllObjects];
                    
                    numArr3 = [self splitNumberIntoArrWith:[obj3 intValue]];
                    
                    int pos32 = [[numArr3 objectAtIndex:1] intValue];
                    
                    int pos33 = [[numArr3 objectAtIndex:2] intValue];
                    
                    int pos34 = [[numArr3 objectAtIndex:3] intValue];
                    
                    int pos35 = [[numArr3 objectAtIndex:4] intValue];
                    
                    NSString *col2 = [NSString stringWithFormat:@"%d%d%d",pos12,pos22,pos32];
                    
                    if (![self isNumberStartWith:col2 inArr:generalArr])
                        continue;
                    
                    NSString *col3 = [NSString stringWithFormat:@"%d%d%d",pos13,pos23,pos33];
                    
                    if (![self isNumberStartWith:col3 inArr:generalArr])
                        continue;
                    
                    NSString *col4 = [NSString stringWithFormat:@"%d%d%d",pos14,pos24,pos34];
                    
                    if (![self isNumberStartWith:col4 inArr:generalArr])
                        continue;
                    
                    NSString *col5 = [NSString stringWithFormat:@"%d%d%d",pos15,pos25,pos35];
                    
                    if (![self isNumberStartWith:col5 inArr:generalArr])
                        continue;
                    
                    NSString *strObj31 = [NSString stringWithFormat:@"%d%d%d",pos11,pos22,pos33];
                    
                    if (![self isNumberStartWith:strObj31 inArr:diag1Arr])
                        continue;
                    
                    NSString *strObj32 = [NSString stringWithFormat:@"%d%d%d",pos15,pos24,pos33];
                    
                    if (![self isNumberStartWith:strObj32 inArr:diag2Arr])
                        continue;
                    
                    for (id obj4 in rs4number[3]) {
                        
                        NSMutableArray *numArr4 = [[NSMutableArray alloc]init];
                        
                        [numArr4 removeAllObjects];
                        
                        numArr4 = [self splitNumberIntoArrWith:[obj4 intValue]];
                        
                        int pos42 = [[numArr4 objectAtIndex:1] intValue];
                        
                        int pos43 = [[numArr4 objectAtIndex:2] intValue];
                        
                        int pos44 = [[numArr4 objectAtIndex:3] intValue];
                        
                        int pos45 = [[numArr4 objectAtIndex:4] intValue];
                        
                        NSString *col2 = [NSString stringWithFormat:@"%d%d%d%d",pos12,pos22,pos32,pos42];
                        
                        if (![self isNumberStartWith:col2 inArr:generalArr])
                            continue;
                        
                        NSString *col3 = [NSString stringWithFormat:@"%d%d%d%d",pos13,pos23,pos33,pos43];
                        
                        if (![self isNumberStartWith:col3 inArr:generalArr])
                            continue;
                        
                        NSString *col4 = [NSString stringWithFormat:@"%d%d%d%d",pos14,pos24,pos34,pos44];
                        
                        if (![self isNumberStartWith:col4 inArr:generalArr])
                            continue;
                        
                        NSString *col5 = [NSString stringWithFormat:@"%d%d%d%d",pos15,pos25,pos35,pos45];
                        
                        if (![self isNumberStartWith:col5 inArr:generalArr])
                            continue;
                        
                        NSString *strObj41 = [NSString stringWithFormat:@"%d%d%d%d",pos11,pos22,pos33,pos44];
                        
                        if (![self isNumberStartWith:strObj41 inArr:diag1Arr])
                            continue;
                        
                        NSString *strObj42 = [NSString stringWithFormat:@"%d%d%d%d",pos15,pos24,pos33,pos42];
                        
                        if (![self isNumberStartWith:strObj42 inArr:diag2Arr])
                            continue;
                        
                        if (![self isNumberStartWith:col5 inArr:rs4number[4]])
                            continue;
                        
                        for (id obj5 in rs4number[4]) {
                            
                            NSMutableArray *numArr5 = [[NSMutableArray alloc]init];
                            
                            [numArr5 removeAllObjects];
                            
                            numArr5 = [self splitNumberIntoArrWith:[obj5 intValue]];
                            
                            int pos51 = [[numArr5 objectAtIndex:0] intValue];
                            
                            int pos52 = [[numArr5 objectAtIndex:1] intValue];
                            
                            int pos53 = [[numArr5 objectAtIndex:2] intValue];
                            
                            int pos54 = [[numArr5 objectAtIndex:3] intValue];
                            
                            int pos55 = [[numArr5 objectAtIndex:4] intValue];
                            
                            NSString *col2 = [NSString stringWithFormat:@"%d%d%d%d%d",pos12,pos22,pos32,pos42,pos52];
                            
                            if (![self isNumberStartWith:col2 inArr:generalArr])
                                continue;
                            
                            NSString *col3 = [NSString stringWithFormat:@"%d%d%d%d%d",pos13,pos23,pos33,pos43,pos53];
                            
                            if (![self isNumberStartWith:col3 inArr:generalArr])
                                continue;
                            
                            NSString *col4 = [NSString stringWithFormat:@"%d%d%d%d%d",pos14,pos24,pos34,pos44,pos54];
                            
                            if (![self isNumberStartWith:col4 inArr:generalArr])
                                continue;
                            
                            NSString *col5 = [NSString stringWithFormat:@"%d%d%d%d%d",pos15,pos25,pos35,pos45,pos55];
                            
                            if (![self isNumberStartWith:col5 inArr:generalArr])
                                continue;
                            
                            NSString *str1 = [NSString stringWithFormat:@"%d%d%d%d%d",pos11, pos22, pos33, pos44, pos55];
                            
                            NSString *str2 = [NSString stringWithFormat:@"%d%d%d%d%d",pos15, pos24, pos33, pos42, pos51];
                            
                            NSNumber *diag1 = [NSNumber numberWithInt:[str1 intValue]];
                            
                            NSNumber *diag2 = [NSNumber numberWithInt:[str2 intValue]];
                            
                            if ([generalArr containsObject:diag1] && [generalArr containsObject:diag2]) {
                                
                                NSArray *arrAdd = @[obj1, obj2, obj3, obj4, obj5];
                                
                                [rsArr addObject:arrAdd];
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSLog(@"Results: %lu", [rsArr count]);
    
    return rsArr;
}

@end
