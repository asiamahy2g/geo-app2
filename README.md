# geoapp (patients_geolocation)

Spring Boot app to locate patients so medical specialists can plan home appointments. It runs on port 8082 and uses an in-memory H2 database.

## Build and run locally

```
./mvnw clean package
java -jar target/bioMedical-*.jar
```

Then open http://localhost:8082. Set `MAIL_PASSWORD` in the environment if you need outgoing email.

## CI/CD

- **Build and push image** (`.github/workflows/build.yml`) runs on every push to `main`. It builds the jar, builds the Docker image and pushes it to ECR as `geoapp:<short commit SHA>` and `geoapp:latest`.
- **Deploy to EKS** (`.github/workflows/deploy.yml`) runs `helm upgrade` with the `chart/` Helm chart. It runs after each build, or by hand from the Actions tab (leave the tag empty to deploy the newest image). Every deploy waits for approval in the `geoapp-prod` environment, and is skipped if no `manny-eks-*` cluster is running.

Both workflows sign in to AWS with OIDC (roles `github-actions-geoapp-ecr-push` and `github-actions-geoapp-deploy`); there are no stored AWS keys.

The cluster itself is managed in [asiamahy2g/eks-terraform](https://github.com/asiamahy2g/eks-terraform).