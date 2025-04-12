// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.5.1
// - protoc             (unknown)
// source: counter/v1/counter.proto

package v1

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.64.0 or later.
const _ = grpc.SupportPackageIsVersion9

const (
	CounterService_FetchCounter_FullMethodName  = "/counter.v1.CounterService/FetchCounter"
	CounterService_InsertCounter_FullMethodName = "/counter.v1.CounterService/InsertCounter"
)

// CounterServiceClient is the client API for CounterService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type CounterServiceClient interface {
	FetchCounter(ctx context.Context, in *FetchCounterRequest, opts ...grpc.CallOption) (*FetchCounterResponse, error)
	InsertCounter(ctx context.Context, in *InsertCounterRequest, opts ...grpc.CallOption) (*InsertCounterResponse, error)
}

type counterServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewCounterServiceClient(cc grpc.ClientConnInterface) CounterServiceClient {
	return &counterServiceClient{cc}
}

func (c *counterServiceClient) FetchCounter(ctx context.Context, in *FetchCounterRequest, opts ...grpc.CallOption) (*FetchCounterResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(FetchCounterResponse)
	err := c.cc.Invoke(ctx, CounterService_FetchCounter_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *counterServiceClient) InsertCounter(ctx context.Context, in *InsertCounterRequest, opts ...grpc.CallOption) (*InsertCounterResponse, error) {
	cOpts := append([]grpc.CallOption{grpc.StaticMethod()}, opts...)
	out := new(InsertCounterResponse)
	err := c.cc.Invoke(ctx, CounterService_InsertCounter_FullMethodName, in, out, cOpts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// CounterServiceServer is the server API for CounterService service.
// All implementations must embed UnimplementedCounterServiceServer
// for forward compatibility.
type CounterServiceServer interface {
	FetchCounter(context.Context, *FetchCounterRequest) (*FetchCounterResponse, error)
	InsertCounter(context.Context, *InsertCounterRequest) (*InsertCounterResponse, error)
	mustEmbedUnimplementedCounterServiceServer()
}

// UnimplementedCounterServiceServer must be embedded to have
// forward compatible implementations.
//
// NOTE: this should be embedded by value instead of pointer to avoid a nil
// pointer dereference when methods are called.
type UnimplementedCounterServiceServer struct{}

func (UnimplementedCounterServiceServer) FetchCounter(context.Context, *FetchCounterRequest) (*FetchCounterResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method FetchCounter not implemented")
}
func (UnimplementedCounterServiceServer) InsertCounter(context.Context, *InsertCounterRequest) (*InsertCounterResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method InsertCounter not implemented")
}
func (UnimplementedCounterServiceServer) mustEmbedUnimplementedCounterServiceServer() {}
func (UnimplementedCounterServiceServer) testEmbeddedByValue()                        {}

// UnsafeCounterServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to CounterServiceServer will
// result in compilation errors.
type UnsafeCounterServiceServer interface {
	mustEmbedUnimplementedCounterServiceServer()
}

func RegisterCounterServiceServer(s grpc.ServiceRegistrar, srv CounterServiceServer) {
	// If the following call pancis, it indicates UnimplementedCounterServiceServer was
	// embedded by pointer and is nil.  This will cause panics if an
	// unimplemented method is ever invoked, so we test this at initialization
	// time to prevent it from happening at runtime later due to I/O.
	if t, ok := srv.(interface{ testEmbeddedByValue() }); ok {
		t.testEmbeddedByValue()
	}
	s.RegisterService(&CounterService_ServiceDesc, srv)
}

func _CounterService_FetchCounter_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(FetchCounterRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CounterServiceServer).FetchCounter(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CounterService_FetchCounter_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CounterServiceServer).FetchCounter(ctx, req.(*FetchCounterRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _CounterService_InsertCounter_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(InsertCounterRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(CounterServiceServer).InsertCounter(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: CounterService_InsertCounter_FullMethodName,
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(CounterServiceServer).InsertCounter(ctx, req.(*InsertCounterRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// CounterService_ServiceDesc is the grpc.ServiceDesc for CounterService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var CounterService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "counter.v1.CounterService",
	HandlerType: (*CounterServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "FetchCounter",
			Handler:    _CounterService_FetchCounter_Handler,
		},
		{
			MethodName: "InsertCounter",
			Handler:    _CounterService_InsertCounter_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "counter/v1/counter.proto",
}
