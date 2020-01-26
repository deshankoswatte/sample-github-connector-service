# sample-github-connector-service

## Table of Contents

* [About the Project](#about-the-project)
* [Try out the project](#try-out-the-project)
* [Contributing](#contributing)
* [License](#license)
* [References](#references)

## About the project

A sample github connector service implemented using ballerina which invokes github API services to retrieve, post and update data related to github issues.

## Try out the project

1. Change the constant values: `ORGANIZATION_NAME`, `REPOSITORY_NAME` and `ACCESS_TOKEN` located inside the file `constants.bal` located at **sample-github-connector-service/src/github_service/** to suit your repository of choice.

2. Import the postman collection `sample-github-services.postman_collection.json` located at **sample-github-connector-service/src/github_service/resources/** to postman.

3. Change the **parameters and body values** and then, test out the requests.

## Contributing

Contributions make the open source community such an amazing place to learn, inspire, and create. Any contribution you make to this project is **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

## License

Distributed under the Apache License 2.0. See `LICENSE` for more information.

## References

- https://developer.github.com/v3/issues/ - List of GitHub API service descriptions.
