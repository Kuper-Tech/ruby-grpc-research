# Ruby Grpc Research

## Griffin

```shell
DS9_USE_SYSTEM_LIBRARIES=true bundle install
ruby griffin/server.rb
```

### Results

```
GoError: connection error: desc = "transport: error while dialing: dial tcp 192.168.88.158:50051: connect: can't assign requested address"
Error raised Resource temporarily unavailable - accept(2) would block

     ✓ status is OK
     ✓ message is correct

     checks...............: 100.00% 60262 out of 60262
     data_received........: 2.9 MB  41 kB/s
     data_sent............: 7.5 MB  107 kB/s
     grpc_req_duration....: avg=9.11ms min=1.16ms  med=3.53ms max=1.27s  p(90)=16.91ms p(95)=22.29ms
     iteration_duration...: avg=1.09s  min=10.54ms med=1s     max=22.94s p(90)=1.22s   p(95)=1.5s   
     iterations...........: 33936   481.239167/s
     vus..................: 30      min=27             max=1000
     vus_max..............: 1000    min=1000           max=1000


running (1m10.5s), 0000/1000 VUs, 33936 complete and 0 interrupted iterations
default ✓ [======================================] 0000/1000 VUs  1m10s
```

## Gruf

```shell
bundle install
ruby gruf/server.rb
```

### Results
```
     scenarios: (100.00%) 1 scenario, 1000 max VUs, 1m40s max duration (incl. graceful stop):
              * default: Up to 1000 looping VUs for 1m10s over 5 stages (gracefulRampDown: 30s, gracefulStop: 30s)


     ✗ status is OK
      ↳  93% — ✓ 39316 / ✗ 2690
     ✗ message is correct
      ↳  93% — ✓ 39316 / ✗ 2690

     checks...............: 93.59% 78632 out of 84012
     data_received........: 11 MB  153 kB/s
     data_sent............: 11 MB  157 kB/s
     grpc_req_duration....: avg=18.81ms min=1.35ms med=10.46ms max=365.92ms p(90)=48.36ms p(95)=57.59ms
     iteration_duration...: avg=1.02s   min=1s     med=1.01s   max=1.37s    p(90)=1.05s   p(95)=1.06s  
     iterations...........: 42006  594.37972/s
     vus..................: 37     min=27             max=1000
     vus_max..............: 1000   min=1000           max=1000


running (1m10.7s), 0000/1000 VUs, 42006 complete and 0 interrupted iterations
default ✓ [======================================] 0000/1000 VUs  1m10s
```

## Golang gRPC server
```shell
cd golang

go mod tidy
go run main.go
```

### Results

```
GoError: connection error: desc = "transport: error while dialing: dial tcp 192.168.88.158:50051: connect: can't assign requested address"

     ✓ status is OK
     ✓ message is correct

     checks...............: 100.00% 70940 out of 70940
     data_received........: 4.8 MB  68 kB/s
     data_sent............: 9.4 MB  133 kB/s
     grpc_req_duration....: avg=47ms  min=953.38µs med=2.67ms max=2.39s p(90)=13.84ms p(95)=32.22ms
     iteration_duration...: avg=1.06s min=7.9ms    med=1s     max=3.96s p(90)=1.2s    p(95)=1.29s  
     iterations...........: 38208   538.203944/s
     vus..................: 10      min=10             max=1000
     vus_max..............: 1000    min=1000           max=1000


running (1m11.0s), 0000/1000 VUs, 38208 complete and 0 interrupted iterations
default ✓ [======================================] 0000/1000 VUs  1m10s
```

## k6

```shell
k6 run k6_test_grpc.js
```

## Total comparison table

| server  | checks | received | sent     | req_duration, ms (avg / p90 / p95) | iter_duration, ms  | iter_count | iter_rps |
|---------|--------|----------|----------|------------------------------------|--------------------|------------|----------|
| griffin | 60262  | 41 kB/s  | 107 kB/s | 9.11 / 16.91 / 22.29               | 1090 / 1220 / 1500 | 33936      | 481.2    |
| gruf    | 78632  | 153 kB/s | 157 kB/s | 18.81 / 48.36 / 57.59              | 1020 / 1050 / 1060 | 42006      | 594.3    |
| golang  | 70940  | 68 kB/s  | 133 kB/s | 47 / 13.84 / 32.22                 | 1060 / 1200 / 1290 | 38208      | 538.2    |
