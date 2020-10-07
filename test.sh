cd community-operators/starter-kit-operator
ls
rm -rf $NEW_OPERATOR_VERSION
cp -r $OLD_OPERATOR_VERSION $NEW_OPERATOR_VERSION

mv $NEW_OPERATOR_VERSION/starter-kit-operator.v$OLD_OPERATOR_VERSION.clusterserviceversion.yaml $NEW_OPERATOR_VERSION/starter-kit-operator.v$NEW_OPERATOR_VERSION.clusterserviceversion.yaml

yq write --inplace starter-kit-operator.package.yaml channels[0].currentCSV starter-kit-operator.v$NEW_OPERATOR_VERSION

SKIT_CSV=$NEW_OPERATOR_VERSION/starter-kit-operator.v$NEW_OPERATOR_VERSION.clusterserviceversion.yaml

yq write --inplace $SKIT_CSV metadata.annotations.containerImage ibmcom/starter-kit-operator:$IMAGE_TAG
yq write --inplace $SKIT_CSV metadata.name starter-kit-operator.v$NEW_OPERATOR_VERSION
yq write --inplace $SKIT_CSV spec.install.spec.deployments[0].spec.template.spec.containers[0].image ibmcom/starter-kit-operator:$IMAGE_TAG
yq write --inplace $SKIT_CSV spec.replaces starter-kit-operator.v$OLD_OPERATOR_VERSION
yq write --inplace $SKIT_CSV spec.version $NEW_OPERATOR_VERSION

git add .
git commit -m "Update IBM Starter Kit operator to v$NEW_OPERATOR_VERSION"

echo Open a PR against the parent repo here: https://github.com/operator-framework/community-operators/pulls
