# geoapp (patients_geolocation)

Spring Boot app to locate patients so medical specialists can plan home appointments. It runs on port 8082 and uses an in-memory H2 database.

## Build and run locally

```
./mvnw clean package
java -jar target/bioMedical-*.jar
```

Then open http://localhost:8082. Set `MAIL_PASSWORD` in the environment if you need outgoing email.

## CI/CD

`.github/workflows/build.yml` (CI/CD) runs these stages; each one must pass before the next:

1. **Lint**: `hadolint` on the Dockerfile, `helm lint --strict` on `chart/`
2. **Build and unit test**: `mvn verify` on Java 11, with a JaCoCo coverage report
3. **Code quality**: SonarQube Cloud analysis ([project](https://sonarcloud.io/summary/overall?id=asiamahy2g_geo-app2)); the job fails if the quality gate fails. Authentication is secretless (OIDC), so there is no `SONAR_TOKEN` secret. Front-end libraries under `src/main/resources/static/` are excluded from analysis.
4. **Image**: Docker build and a Trivy scan for HIGH/CRITICAL CVEs. Results go to the repo's *Security > Code scanning* tab. The scan reports but doesn't block yet.
5. **Push** to ECR as `geoapp:<short commit SHA>` and `geoapp:latest` (pushes to `main` only)
6. **Deploy** to EKS with the `chart/` Helm chart, after approval in the `geoapp-prod` environment (pushes to `main` only)

Pull requests run stages 1-4 and get SonarQube Cloud results on the PR; nothing is pushed or deployed.

**Deploy to EKS** (`.github/workflows/deploy.yml`) can also be run by hand from the Actions tab, for example after rebuilding the cluster. Leave the tag empty to deploy the newest image. It skips cleanly if no `manny-eks-*` cluster is running.

AWS access uses OIDC (roles `github-actions-geoapp-ecr-push` and `github-actions-geoapp-deploy`); there are no stored AWS keys.

The cluster itself is managed in [asiamahy2g/eks-terraform](https://github.com/asiamahy2g/eks-terraform).