import grpc from 'k6/net/grpc';
import { check, sleep } from 'k6';

const client = new grpc.Client();
client.load(['shared/proto'], 'hello.proto');

export const options = {
  stages: [
//    { duration: '30s', target: 1000 },
    { duration: '10s', target: 1000 },
//    { duration: '10s', target: 750 },
//    { duration: '10s', target: 500 },
//    { duration: '10s', target: 0 },
  ],
};

export default () => {
  client.connect(__ENV.TARGET_HOST + ":9091", { plaintext: true });

  const data = { name: 'k6' };
  const response = client.invoke('hello.Greeter/SayHello', data);

  check(response, {
    'status is OK': (r) => r && r.status === grpc.StatusOK,
    'message is correct': (r) => r && r.message.message === 'Hello, k6!',
  });

  client.close();
  sleep(1);
};
