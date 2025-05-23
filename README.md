# Code and CI/CD Pipeline assessment

## Terraform 

I chose to use linode as the cloud provider, and coded the entire setup using IaC (Infrastructure as Code) using Terraform. The code is located in the `terraform` directory.

There is a state bucket used to manage the state.

I used istio as the service mesh, I prefer it to nginx ingress because it secures the communication between the pods, kubernetes does not do this by default.

## Ozone

[Ozone](https://github.com/ozone2021/ozone) is my personal open source project which is a build pipeline framework.

It allows for modularity and reusability of code. It allows developers to decouple their build process from their CI/CD 
provider, because coupling is a well established anti-pattern.

It is quite well documented if you would like to read how it works.

## The deployed app

The app is a simple golang app that returns a health check message. 

## CI/CD

I used Github Actions in tandem with my own open source project Ozone to create a CI/CD pipeline. The pipeline is located in the `.github/workflows` directory.

## How it works

When a PR is opened, a workflow builds all the docker images and deploys these to a sandbox in a kubernetes namespace.

When the PR is merged, the sandbox is deleted, and the images are built again in the main branch.

This style of work negates the need for a large amount of environments and is in my opinion, is the essence of devops.

There is no siloisation of dev, qa, staging and prod. There is only one environment, and that is the sandbox. The sandbox allows
all teams to work together, and the work can be tested with all eyes on the code.

Too many times, I've witnessed backend developers write code, while frontend developers are working on other functionality, and when
it comes time for the frontend developers to work on the new backend code, they find issues with it. QA aren't the only people that
find issues with code. This can cause serious problems if there has been lots of code merged since the backend code was written, as if it 
is a breaking change, it can be difficult to revert the code.

It also slows down development because the backend developers have to context switch back and try to remember what it was that they were doing.

With sandboxes, the PR can remain open and it makes it very easy for cross team collaboration, and if there is a time delay between frontend
catching up to do their part of the work, the backend code is there in a PR, so the backend devs can easily read the PR and understand what it is they were doing.

This also makes it easy for QA to test the code before it gets merged. There is also a simple end to end test that runs as part of the sandbox, as a proof
of concept of how this can be expanded upon by developers and QA. Testing is everyone's responsibility.

When the PR is merged, a workflow is started in which the sandbox is deleted. This means that there is no need to worry about cleaning up the environment.

### Cost savings

The cost of running a sandbox is much cheaper than running multiple environments as sandboxes are ephemeral. The sandboxes can run in the same kubernetes cluster as the development
cluster. If there is going to be a long time before the frontend team can catch up, the sandbox can be manually deleted and recreated when the frontend team is ready to work on it.

## CI/CD process 

The sandbox containers are tagged using the following commmand:

```bash
git log -n 1 --pretty=format:%%H --  %s
```

Where %s is a list of all the source files. The output is a single git commit hash. The most recent git hash of any of the files, so that if any of the files change,
then the hash will change. This allows a unique tag to be generated for a change set.

Due to the fact that we can ascertain this git hash before we build, a script can run to check if the docker registry already contains the docker image, and
if it does, then the image is not built. This saves time and money. It's a form of caching.

```yaml
context_conditionals:
  - context: "{{NS_CONTEXTS}}"
    when_not_script:
      - script/dockerhub_has_container.sh
```

### The main containers

The main containers are tagged with version numbers. I personally like to have a release branch, with the semantic version as the suffix.

However, due to time constraints on this project, I did not implement this.

### Immutability of containers

I find it to be best practice to have 2 docker registries for each service. One for development and one for production. The production registry 
should be immutable. The benefit of this is garbage collection. We can just delete the images in the development registry without any concern of it 
causing problems in production.

## Testing

As mentioned earlier, there is end-to-end testing performed against the sandbox endpoint. This ensures the pipeline works correctly.

I don't have any spare domain names and it would be beyond the scope of this task to implement a DNS record, so I wrote a script to retrieve
the IP address from the load balancer generated by Linode, then added this to the /etc/hosts file of the github action VM, then passed in the endpoint
to the newman test runner, as sandboxes all have different endpoints (such as feat12-api.ivanti.com/health).

Newman is the CLI version of postman. I wrote test scripts in postman and exported the collection. The pipeline will fail if these tests fail.

#### Here is what the test looks like:

```javascript
pm.test("Status code is 200", function () {
  pm.response.to.have.status(200);
});

pm.test("The response has all properties", () => {
    //parse the response JSON and test three properties
    const responseJson = pm.response.json();
    pm.expect(responseJson.status).to.eql('healthy');
    pm.expect(responseJson.message).to.eql('The application is running smoothly.');
});
```

## Github

There is a branch protection on main so that only pull requests are allowed.
