import Git from 'nodegit';

export const handler = async (event) => {
    const repo = Git.Clone("https://github.com/nodegit/nodegit", "./tmp");

    console.log(repo);
};
