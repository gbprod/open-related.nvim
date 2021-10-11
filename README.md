# open-related.nvim
Draft - Quickly open related files in neovim using Telescope
Work in progress, API could change.

## Motivation

The aim is to quickly open (and create ?) files related to the current one. For example, we
want to go to the test file or to the implementation, or go to the header file...

## Usage

Open relations using vim command `OpenRelated` or `Telescope related`.

## setup

```lua
-- install using packer
use("gbprod/open-related", {
    requires = { 
        { 'nvim-lua/plenary.nvim' }, 
        { 'nvim-telescope/telescope.nvim' } 
    }
})

open_related = require('open-related')
open_related.setup{}

-- This will add a simple relation
open_related.add_relation({
    -- Filetypes where the relation apply
    filetypes = { 'php' },
    -- Does the relation should apply
    condition = function(bufnr)
        return true
    end,
    -- return relations
    related_to = function(bufnr, opts)
        return {}
    end,
    -- Options that will be passed to the related_to function
    opts = {},
})
```

The `related_to` function should return a table of : 

```lua
{
    file = "exact/match", -- If present, this is the path from cwd of an expected relation
}
```

## Helpers

Helpers can simplify creating relations.

### Find relations based on the filename

`from_patterns` will allows to tranform filename in order to find the related files.
The basic example will be to find the C++ header file (and reverse).

```lua
open_related.add_relation({
    filetypes = { 'cpp' },
    related_to = filename.from_patterns({
        -- This will capture the part before the `.h` (using lua `match` function) 
        -- and apply it to associated pattern (using lua `format` function)
        { match = "(.*).h$", format = "%s.cpp"},
        { match = "(.*).cpp$", format = "%s.h" },
    }),
})
```

## Builtins

This comes with some builtin relations for some languages, this allows to use "well-known" relations.

You can override builtins options using the `with` method.

### C++

Alternate throught the header and the implementation file.

```lua
open_related.add_relation(
    require("open-related.builtin.cpp").alternate_header
)
```

### php

Alternate throught test files.
eg. `src/Model/Product.php` <=> `tests/Model/ProductTest.php` 

```lua
open_related.add_relation(
    require("open-related.builtin.php").alternate_test_file
)
```

You can specify additionnal tests namespace prefixes using the `test_namespace_prefixes`
```lua
open_related.add_relation(
    require("open-related.builtin.php").alternate_test_file.with({
        opts = {
            test_namespace_prefixes = { "Integration", "Unit" },
        },
    })
)
```
This will match : `src/Model/Product.php` <=> `tests/Model/ProductTest.php` and `tests/Unit/Model/ProductTest.php` and `tests/Integration/Model/ProductTest.php` 

## Todo

 - Symfony template rule
 - Php dependencies rules
 - vimdoc
 - approximative match using ripgrep
 - allow file creation
 - Support more than telescope
