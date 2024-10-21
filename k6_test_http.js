import http from 'k6/http';
export const options = {
  stages: [
//    { duration: '30s', target: 1000 },
    { duration: '10s', target: 1000 },
//    { duration: '10s', target: 750 },
//    { duration: '10s', target: 500 },
//    { duration: '10s', target: 0 },
  ],
};


export default function () {
  for (let id = 1; id <= 100; id++) {
    http.get("http://client:9292/" + __ENV.TARGET_HOST);
  }
}
