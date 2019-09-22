.PHONY: image push test

push: image
	docker push kodgruvan/git-repo-banner:latest

test: image
	docker run -v $$(pwd):/code kodgruvan/git-repo-banner:latest $$(hostname) "Git Repo Banner" 1.2a America/Los_Angeles

image:
	docker build . -t kodgruvan/git-repo-banner:latest

