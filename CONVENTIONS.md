This convention applies to all documents in this repository, including contributor-related, such as [CONTRIBUTING.md](./CONTRIBUTING.md).

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

There're 4 types of line: Text, Heading, Code and Mixed.

- Text: The line is fully text. It doesn't have code or headings.
- Heading: The line starts with one or multiple hashtags, which markdown formatting changes to heading.
- Code: The line is inside code block or is starting or ending a code block.
- Mixed: Text or Heading lines that contain a code block.
  Each of those follow their own rules, as defined below.

- Text inside parentheses counts as comments in Text lines.
- Functions with `WIP` in the description are in work. They are prone to change and can be unstable but they're ready for use.
- Functions with `TBD` in the description are yet to be ready to be used. Using them is not supported and I won't provide support for them.
- Functions with `PERSONAL` in the description are meant only for my personal use. They're not supported, unexpected behaviour should be expected (yes, this is a pun).
- All documents in this repository MUST be written in simple present tense.
- Sentences MUST be written in active voice.
- Simple English SHOULD be used. Avoid jargon and complex vocabulary where possible.
- Bullet lists SHOULD be used where applicable.
- Each line of text SHOULD contain only one sentence and MUST end with either period or colon.
- Docs MUST be in markdown.
- Headings MUST NOT end with punctuation mark.
- Code MUST be inside code blocks with syntax highlighting corresponding to the language they're written in.
- Mixed lines MUST follow Heading or Text rules, depending if they start with hashtag or not.
- Docs MUST be formatted using the Prettier formatter.
