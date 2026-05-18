# Treewide Changes

Generally, when doing changes that affect large batches of packages, it is
recommended to put all of these changes into tree-wide merge requests.
Generally, only one commit should be made for the entire change, with the
exception of very small changes, such as touching only a few packages, or
if splitting the changes into smaller commits would make the git history
easier to follow.

## Treewides for CI Changes

If a change in policy is made that will be enforced with CI, in most cases it
is recommended to migrate all packages with a treewide before enforcing the
changes. The CI change can be a part of the a treewide as a separate commit if
deemed better than as a separate merge request.

## Commit Template

### Single Commit

Commit messages should be as follows:

```
treewide: short description of change

Longer explanation of why the change is being done, linking to any relevent
discussions, policies, or previous commits.
```

An example of this could be:

```
treewide: migrate kernels to install modules to /usr/

Since the project has decided to implement the usr-merge, modules will always
be installed to /usr/ at runtime. This updates packaging to reflect the
runtime directories.

https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/85504
f804025f55a6bfc8ef174d3a37c33124a102ff46
```

### Multi-Commit

If the choice is made to split a tree-wide merge request into smaller commits,
only the first commit needs an explanation of the change, with the following
only containing the title. The following template can be used instead:

```
treewide: logical segment: short description of change
```

An example of this could be:

```
treewide: device/testing: migrate firmware to /usr/
```
