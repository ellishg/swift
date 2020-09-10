// RUN: %target-swift-emit-ir -import-objc-header %S/../Inputs/objc_direct.h -o - %s | %FileCheck %s

// REQUIRES: objc_interop

func markUsed<T>(_ t: T) {}

protocol BarProtocol {
    func directProtocolMethod() -> String!
}

extension Bar: BarProtocol {}

let bar = Bar()

bar.directProperty = 123
// CHECK: call void @"\01-[Bar setDirectProperty:]"({{.*}}, i8* undef, i32 {{.*}})

markUsed(bar.directProperty)
// CHECK: call i32 @"\01-[Bar directProperty]"({{.*}}, i8* undef)

bar.directProperty2 = 456
// CHECK: call void @"\01-[Bar setDirectProperty2:]"({{.*}}, i8* undef, i32 {{.*}})

markUsed(bar.directProperty2)
// CHECK: call i32 @"\01-[Bar directProperty2]"({{.*}}, i8* undef)

bar[0] = 789
// CHECK: call void @"\01-[Bar setObject:atIndexedSubscript:]"({{.*}}, i8* undef, i32 789, i32 0)

markUsed(bar[0])
// CHECK: call i32 @"\01-[Bar objectAtIndexedSubscript:]"({{.*}}, i8* undef, i32 0)

markUsed(bar.directMethod())
// CHECK: call {{.*}} @"\01-[Bar directMethod]"({{.*}}, i8* undef)

markUsed(bar.directMethod2())
// CHECK: call {{.*}} @"\01-[Bar directMethod2]"({{.*}}, i8* undef)

markUsed(Bar.directClassMethod())
// CHECK: call {{.*}} @"\01+[Bar directClassMethod]"({{.*}}, i8* undef)

markUsed(Bar.directClassMethod2())
// CHECK: call {{.*}} @"\01+[Bar directClassMethod2]"({{.*}}, i8* undef)

markUsed(bar.directProtocolMethod())
// CHECK: call {{.*}} @"\01-[Bar directProtocolMethod]"({{.*}}, i8* undef)

// CHECK-DAG: declare i32 @"\01-[Bar directProperty]"
// CHECK-DAG: declare void @"\01-[Bar setDirectProperty:]"
// CHECK-DAG: declare i32 @"\01-[Bar directProperty2]"
// CHECK-DAG: declare void @"\01-[Bar setDirectProperty2:]"
// CHECK-DAG: declare void @"\01-[Bar setObject:atIndexedSubscript:]"
// CHECK-DAG: declare i32 @"\01-[Bar objectAtIndexedSubscript:]"
// CHECK-DAG: declare {{.*}} @"\01-[Bar directMethod]"
// CHECK-DAG: declare {{.*}} @"\01-[Bar directMethod2]"
// CHECK-DAG: declare {{.*}} @"\01+[Bar directClassMethod]"
// CHECK-DAG: declare {{.*}} @"\01+[Bar directClassMethod2]"
// CHECK-DAG: declare {{.*}} @"\01-[Bar directProtocolMethod]"
