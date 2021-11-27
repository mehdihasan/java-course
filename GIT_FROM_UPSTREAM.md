https://www.quora.com/How-do-I-update-my-fork-with-the-original-repo-and-also-update-my-local-in-Git?share=1

```bash
git remote add upstream git@github.com:qala-io/java-course.git
```

```bash
git fetch upstream
```

```bash
git merge upstream/master
```