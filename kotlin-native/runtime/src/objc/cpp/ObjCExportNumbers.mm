/*
 * Copyright 2010-2018 JetBrains s.r.o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#if KONAN_OBJC_INTEROP

#import <Foundation/Foundation.h>

#import "ObjCExport.h"
#import "Runtime.h"
#import "concurrent/Mutex.hpp"

extern "C" {

OBJ_GETTER(Kotlin_boxBoolean, KBoolean value);
OBJ_GETTER(Kotlin_boxByte, KByte value);
OBJ_GETTER(Kotlin_boxShort, KShort value);
OBJ_GETTER(Kotlin_boxInt, KInt value);
OBJ_GETTER(Kotlin_boxLong, KLong value);
OBJ_GETTER(Kotlin_boxUByte, KUByte value);
OBJ_GETTER(Kotlin_boxUShort, KUShort value);
OBJ_GETTER(Kotlin_boxUInt, KUInt value);
OBJ_GETTER(Kotlin_boxULong, KULong value);
OBJ_GETTER(Kotlin_boxFloat, KFloat value);
OBJ_GETTER(Kotlin_boxDouble, KDouble value);

}

#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

@interface KotlinNumber : NSNumber
@end

[[ noreturn ]] static void incorrectNumberInitialization(KotlinNumber* self, SEL _cmd) {
  [NSException raise:NSGenericException format:@"%@ can't be initialized with %s, use properly typed initialized",
    NSStringFromClass([self class]), sel_getName(_cmd)];

  abort();
}

[[ noreturn ]] static void incorrectNumberFactory(Class self, SEL _cmd) {
  [NSException raise:NSGenericException format:@"%@ can't be created with %s, use properly typed factory",
    NSStringFromClass(self), sel_getName(_cmd)];

  abort();
}

@implementation KotlinNumber : NSNumber

- (NSNumber *)initWithBool:(BOOL)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithChar:(char)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithShort:(short)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithInt:(int)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithInteger:(NSInteger)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithLong:(long)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithLongLong:(long long)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedChar:(unsigned char)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedShort:(unsigned short)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedInt:(unsigned int)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedInteger:(NSUInteger)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedLong:(unsigned long)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithUnsignedLongLong:(unsigned long long)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithFloat:(float)value { incorrectNumberInitialization(self, _cmd); }
- (NSNumber *)initWithDouble:(double)value { incorrectNumberInitialization(self, _cmd); }

+ (NSNumber *)numberWithBool:(BOOL)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithChar:(char)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithShort:(short)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithInt:(int)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithInteger:(NSInteger)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithLong:(long)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithLongLong:(long long)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedChar:(unsigned char)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedShort:(unsigned short)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedInt:(unsigned int)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedLong:(unsigned long)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedInteger:(NSUInteger)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithUnsignedLongLong:(unsigned long long)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithFloat:(float)value { incorrectNumberFactory(self, _cmd); }
+ (NSNumber *)numberWithDouble:(double)value { incorrectNumberFactory(self, _cmd); }

@end

/*
The code below is generated by:


fun main(args: Array<String>) {
    println(genBoolean())
    println(genInteger("Byte", "c", "char"))
    println(genInteger("Short", "s", "short"))
    println(genInteger("Int", "i", "int"))
    println(genInteger("Long", "q", "long long"))
    println(genInteger("UByte", "C", "unsigned char"))
    println(genInteger("UShort", "S", "unsigned short"))
    println(genInteger("UInt", "I", "unsigned int"))
    println(genInteger("ULong", "Q", "unsigned long long"))
    println(genFloating("Float", "f", "float"))
    println(genFloating("Double", "d", "double"))
}

private fun genBoolean(): String = """
@interface KotlinBoolean : KotlinNumber
@end

@implementation KotlinBoolean {
  BOOL value_;
}

- (void)getValue:(void *)value {
	*(BOOL*)value = value_;
}

- (instancetype)initWithBool:(BOOL)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithBool:(BOOL)value {
  KotlinBoolean* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

- (BOOL)boolValue {
  return value_;
}

- (char)charValue {
  return value_;
}

- (const char *)objCType {
  return "c";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxBoolean, value_);
}

@end

""".trimIndent()

private fun genInteger(
        name: String,
        encoding: String,
        cType: String,
        kind: String = getNSNumberKind(cType)
) = """
@interface Kotlin$name : KotlinNumber
@end

@implementation Kotlin$name {
  $cType value_;
}

- (void)getValue:(void *)value {
	*($cType*)value = value_;
}

- (instancetype)initWith${kind.capitalize()}:($cType)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWith${kind.capitalize()}:($cType)value {
  Kotlin$name* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- ($cType)${kind}Value {
  return value_;
}

- (const char *)objCType {
  return "$encoding";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_box$name, value_);
}

@end

""".trimIndent()

private fun getNSNumberKind(cType: String) =
        cType.split(' ').joinToString("") { it.capitalize() }.decapitalize()

private fun genFloating(
        name: String,
        encoding: String,
        cType: String,
        kind: String = getNSNumberKind(cType)
): String = """
@interface Kotlin$name : KotlinNumber
@end

@implementation Kotlin$name {
  $cType value_;
}

- (void)getValue:(void *)value {
	*($cType*)value = value_;
}

- (instancetype)initWith${kind.capitalize()}:($cType)value  {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWith${kind.capitalize()}:($cType)value {
  Kotlin$name* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}
${if (cType != "double") """
// Required to convert Swift floating literals.
- (instancetype)initWithDouble:(double)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}
""" else ""}
- ($cType)${kind}Value {
  return value_;
}

- (const char *)objCType {
  return "$encoding";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_box$name, value_);
}

@end

""".trimIndent()
*/

// TODO: consider generating it by compiler.

@interface KotlinBoolean : KotlinNumber
@end

@implementation KotlinBoolean {
  BOOL value_;
}

- (void)getValue:(void *)value {
	*(BOOL*)value = value_;
}

- (instancetype)initWithBool:(BOOL)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithBool:(BOOL)value {
  KotlinBoolean* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

- (BOOL)boolValue {
  return value_;
}

- (char)charValue {
  return value_;
}

- (const char *)objCType {
  return "c";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxBoolean, value_);
}

@end

@interface KotlinByte : KotlinNumber
@end

@implementation KotlinByte {
  char value_;
}

- (void)getValue:(void *)value {
	*(char*)value = value_;
}

- (instancetype)initWithChar:(char)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithChar:(char)value {
  KotlinByte* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (char)charValue {
  return value_;
}

- (const char *)objCType {
  return "c";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxByte, value_);
}

@end

@interface KotlinShort : KotlinNumber
@end

@implementation KotlinShort {
  short value_;
}

- (void)getValue:(void *)value {
	*(short*)value = value_;
}

- (instancetype)initWithShort:(short)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithShort:(short)value {
  KotlinShort* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (short)shortValue {
  return value_;
}

- (const char *)objCType {
  return "s";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxShort, value_);
}

@end

@interface KotlinInt : KotlinNumber
@end

@implementation KotlinInt {
  int value_;
}

- (void)getValue:(void *)value {
	*(int*)value = value_;
}

- (instancetype)initWithInt:(int)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithInt:(int)value {
  KotlinInt* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (int)intValue {
  return value_;
}

- (const char *)objCType {
  return "i";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxInt, value_);
}

@end

@interface KotlinLong : KotlinNumber
@end

@implementation KotlinLong {
  long long value_;
}

- (void)getValue:(void *)value {
	*(long long*)value = value_;
}

- (instancetype)initWithLongLong:(long long)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithLongLong:(long long)value {
  KotlinLong* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (long long)longLongValue {
  return value_;
}

- (const char *)objCType {
  return "q";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxLong, value_);
}

@end

@interface KotlinUByte : KotlinNumber
@end

@implementation KotlinUByte {
  unsigned char value_;
}

- (void)getValue:(void *)value {
	*(unsigned char*)value = value_;
}

- (instancetype)initWithUnsignedChar:(unsigned char)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithUnsignedChar:(unsigned char)value {
  KotlinUByte* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (unsigned char)unsignedCharValue {
  return value_;
}

- (const char *)objCType {
  return "C";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxUByte, value_);
}

@end

@interface KotlinUShort : KotlinNumber
@end

@implementation KotlinUShort {
  unsigned short value_;
}

- (void)getValue:(void *)value {
	*(unsigned short*)value = value_;
}

- (instancetype)initWithUnsignedShort:(unsigned short)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithUnsignedShort:(unsigned short)value {
  KotlinUShort* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (unsigned short)unsignedShortValue {
  return value_;
}

- (const char *)objCType {
  return "S";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxUShort, value_);
}

@end

@interface KotlinUInt : KotlinNumber
@end

@implementation KotlinUInt {
  unsigned int value_;
}

- (void)getValue:(void *)value {
	*(unsigned int*)value = value_;
}

- (instancetype)initWithUnsignedInt:(unsigned int)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithUnsignedInt:(unsigned int)value {
  KotlinUInt* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (unsigned int)unsignedIntValue {
  return value_;
}

- (const char *)objCType {
  return "I";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxUInt, value_);
}

@end

@interface KotlinULong : KotlinNumber
@end

@implementation KotlinULong {
  unsigned long long value_;
}

- (void)getValue:(void *)value {
	*(unsigned long long*)value = value_;
}

- (instancetype)initWithUnsignedLongLong:(unsigned long long)value {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value {
  KotlinULong* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (unsigned long long)unsignedLongLongValue {
  return value_;
}

- (const char *)objCType {
  return "Q";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxULong, value_);
}

@end

@interface KotlinFloat : KotlinNumber
@end

@implementation KotlinFloat {
  float value_;
}

- (void)getValue:(void *)value {
	*(float*)value = value_;
}

- (instancetype)initWithFloat:(float)value  {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithFloat:(float)value {
  KotlinFloat* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

// Required to convert Swift floating literals.
- (instancetype)initWithDouble:(double)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (float)floatValue {
  return value_;
}

- (const char *)objCType {
  return "f";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxFloat, value_);
}

@end

@interface KotlinDouble : KotlinNumber
@end

@implementation KotlinDouble {
  double value_;
}

- (void)getValue:(void *)value {
	*(double*)value = value_;
}

- (instancetype)initWithDouble:(double)value  {
  self = [super init];
  value_ = value;
  return self;
}

+ (instancetype)numberWithDouble:(double)value {
  KotlinDouble* result = [[self new] autorelease];
  result->value_ = value;
  return result;
}

// Required to convert Swift integer literals.
- (instancetype)initWithInteger:(NSInteger)value {
  self = [super init];
  value_ = value; // TODO: check fits.
  return self;
}

- (double)doubleValue {
  return value_;
}

- (const char *)objCType {
  return "d";
}

-(ObjHeader*)toKotlin {
  RETURN_RESULT_OF(Kotlin_boxDouble, value_);
}

@end

#endif // KONAN_OBJC_INTEROP
