![Continuous Integration](https://github.com/aws-samples/cluster-sample-app/actions/workflows/ci.yml/badge.svg)
[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/aws-samples/cluster-sample-app/blob/main/LICENSE)
## Cluster Sample Application
A very basic web application written in Javascript and packaged as a Docker image to be used as a demo when testing clustered deployments.

The application default page displays current date, time as well as the current IP addresses.

Install Node.js and use the following command to install the dependencies:
```
npm install
```

To launch the tests, run:
```
npm test
```

To start locally the application, run:
```
npm start
```

You should then be able to access the application by opening 'http://localhost:3000' in your browser 

## Building your docker image

To build the docker image, go into the root directory of this application and run the following command:
```
docker image build .
```

## Tagging your docker image

To tag the docker image you just built, go into the root directory of this application and run the following command:
```
docker image build -t <yourtag>:latest .
```

## Publishing your docker image

To share your docker image to the Docker Hub Registry or any other registry, publish the docker image you just tagged, go into the root directory of this application and run the following command:
```
docker image push <yourtag>:latest
```

## Running your docker image
To run your docker image locally, run the following command:
```
docker run -p 8090:8080 <yourtag>:latest
```
Or using docker compose:
```
docker compose up clustersampleapp
```

You can then access the application by opening your browser at http://localhost:8090


## License

This sample application is licensed under [the MIT-0 License](https://github.com/aws/mit-0).
