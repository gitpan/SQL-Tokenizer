package SQL::Tokenizer;

use warnings;
use strict;

our $VERSION = '0.06';

sub tokenize {
    my ( $class, $query ) = @_;

    my @query = $query =~ m{
        (
            (?:>=|<=|==)         # >=, <= and == operators
            |
            [\(\),=;]             # punctuation (parenthesis, comma)
            |
            ".*?(?:(?:""){1,}"|(?<!["\\])"(?!")|\\"{2})
                                 # anything inside double quotes, ungreedy
            |
            '.*?(?:(?:''){1,}'|(?<!['\\])'(?!')|\\'{2})
                                 # anything inside single quotes, ungreedy.
            |
            --[\ \t\S]*          # comments
            |
            [^\s\(\),=;]+        # everything that doesn't matches with above
            |
            \n                   # newline
            |
            [\t\ ]+              # any kind of white spaces
        )
    }smxgo;

    return @query;
}

1;

=pod

=head1 NAME

SQL::Tokenizer - A simple SQL tokenizer.

=head1 VERSION

=head1 SYNOPSIS

 use SQL::Tokenizer;

 my $query = q{SELECT 1 + 1};
 my @tokens = SQL::Tokenizer->tokenize($query);

 # @tokens contains ('SELECT', ' ', '1', ' ', '+', ' ', '1')

=head1 DESCRIPTION

SQL::Tokenizer is a simple tokenizer for SQL queries. It does not claim to be
a parser or query verifier. It just creates sane tokens from a valid SQL
query.

It supports SQL with comments like:

 -- This query is used to insert a message into
 -- logs table
 INSERT INTO log (application, message) VALUES (?, ?)

Also supports C<''>, C<""> and C<\'> escaping methods, so tokenizing queries
like the one below should not be a problem:

 INSERT INTO log (application, message)
 VALUES ('myapp', 'Hey, this is a ''single quoted string''!')

=head1 API

=over 4

=item tokenizer

 my @tokens = SQL::Tokenizer->tokenize($query);

This is the only available method. It receives a SQL query, and returns an
array of tokens.

=back

=head1 AUTHOR

Copyright (c) 2007, Igor Sutton Lopes "<IZUT@cpan.org>". All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

