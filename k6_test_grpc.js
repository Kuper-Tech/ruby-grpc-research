import grpc from 'k6/net/grpc';
import { check, sleep } from 'k6';

const client = new grpc.Client();
client.load(['proto'], 'hello.proto');

export const options = {
  vus: 10,
  duration: '30s',
};

export default () => {
  client.connect('localhost:50051', { plaintext: true });

  const data = { name: 'k6' };
  const response = client.invoke('hello.Greeter/SayHello', data);

  check(response, {
    'status is OK': (r) => r && r.status === grpc.StatusOK,
    'message is correct': (r) => r && r.message.message === 'Hello, k6!',
  });

  client.close();
  sleep(1);
};
