-- Capitalize i and other common words

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta

return {
  -- s({ trig = 'i ', snippetType = 'autosnippet' }, {
  --   t 'I ',
  -- }, {
  --   condition = function()
  --     -- check is markdown file
  --     return vim.bo.filetype == 'markdown'
  --   end,
  -- }),
  -- My special acronyms
  s({ trig = 'os ', snippetType = 'autosnippet', desc = 'Computer science: Operating systems' }, {
    t 'OS ',
  }),
  s({ trig = 'Os ', snippetType = 'autosnippet', desc = 'Computer science: Operating systems' }, {
    t 'OS ',
  }),
  s({ trig = 'cpu ', snippetType = 'autosnippet', desc = 'Computer science: Central Processing Unit' }, {
    t 'CPU ',
  }),
  s({ trig = 'cpus ', snippetType = 'autosnippet', desc = 'Computer science: Central Processing Unit' }, {
    t 'CPUs ',
  }),
  s({ trig = 'Cpu ', snippetType = 'autosnippet', desc = 'Computer science: Central Processing Unit' }, {
    t 'CPU ',
  }),
  s({ trig = 'io ', snippetType = 'autosnippet', desc = 'Computer science: Input/Output' }, {
    t 'I/O ',
  }),
  s({ trig = 'Io ', snippetType = 'autosnippet', desc = 'Computer science: Input/Output' }, {
    t 'I/O ',
  }),
  s({ trig = 'cli ', snippetType = 'autosnippet', desc = 'Computer science: commandline interface' }, {
    t 'CLI ',
  }),
  s({ trig = 'csv ', snippetType = 'autosnippet', desc = 'Computer science: comma separated values' }, {
    t 'CSV ',
  }),
  s({ trig = 'csvs ', snippetType = 'autosnippet', desc = 'Computer science: comma separated values' }, {
    t 'CSVs ',
  }),
  s({ trig = 'Csv ', snippetType = 'autosnippet', desc = 'Computer science: comma separated values' }, {
    t 'CSV ',
  }),
  -- Most common countries
  s({ trig = 'england ', snippetType = 'autosnippet' }, {
    t 'England ',
  }),
  s({ trig = 'france ', snippetType = 'autosnippet' }, {
    t 'France ',
  }),
  s({ trig = 'germany ', snippetType = 'autosnippet' }, {
    t 'Germany ',
  }),
  s({ trig = 'italy ', snippetType = 'autosnippet' }, {
    t 'Italy ',
  }),
  s({ trig = 'spain ', snippetType = 'autosnippet' }, {
    t 'Spain ',
  }),
  s({ trig = 'usa ', snippetType = 'autosnippet' }, {
    t 'USA ',
  }),
  s({ trig = 'uk ', snippetType = 'autosnippet' }, {
    t 'UK ',
  }),
  s({ trig = 'eu ', snippetType = 'autosnippet' }, {
    t 'EU ',
  }),
  s({ trig = 'china ', snippetType = 'autosnippet' }, {
    t 'China ',
  }),
  s({ trig = 'russia ', snippetType = 'autosnippet' }, {
    t 'Russia ',
  }),
  s({ trig = 'japan ', snippetType = 'autosnippet' }, {
    t 'Japan ',
  }),
  s({ trig = 'india ', snippetType = 'autosnippet' }, {
    t 'India ',
  }),
  s({ trig = 'brazil ', snippetType = 'autosnippet' }, {
    t 'Brazil ',
  }),
  s({ trig = 'canada ', snippetType = 'autosnippet' }, {
    t 'Canada ',
  }),
  s({ trig = 'australia ', snippetType = 'autosnippet' }, {
    t 'Australia ',
  }),
  s({ trig = 'mexico ', snippetType = 'autosnippet' }, {
    t 'Mexico ',
  }),
  s({ trig = 'south africa ', snippetType = 'autosnippet' }, {
    t 'South Africa ',
  }),
  s({ trig = 'south korea ', snippetType = 'autosnippet' }, {
    t 'South Korea ',
  }),

  -- most common cities
  s({ trig = 'london ', snippetType = 'autosnippet' }, {
    t 'London ',
  }),
  s({ trig = 'paris ', snippetType = 'autosnippet' }, {
    t 'Paris ',
  }),
  s({ trig = 'berlin ', snippetType = 'autosnippet' }, {
    t 'Berlin ',
  }),
  s({ trig = 'rome ', snippetType = 'autosnippet' }, {
    t 'Rome ',
  }),
  s({ trig = 'madrid ', snippetType = 'autosnippet' }, {
    t 'Madrid ',
  }),
  s({ trig = 'new york ', snippetType = 'autosnippet' }, {
    t 'New York ',
  }),
  s({ trig = 'los angeles ', snippetType = 'autosnippet' }, {
    t 'Los Angeles ',
  }),
  s({ trig = 'tokyo ', snippetType = 'autosnippet' }, {
    t 'Tokyo ',
  }),
  s({ trig = 'beijing ', snippetType = 'autosnippet' }, {
    t 'Beijing ',
  }),
  s({ trig = 'moscow ', snippetType = 'autosnippet' }, {
    t 'Moscow ',
  }),
  s({ trig = 'delhi ', snippetType = 'autosnippet' }, {
    t 'Delhi ',
  }),
  s({ trig = 'mumbai ', snippetType = 'autosnippet' }, {
    t 'Mumbai ',
  }),
  s({ trig = 'sao paulo ', snippetType = 'autosnippet' }, {
    t 'Sao Paulo ',
  }),
  s({ trig = 'toronto ', snippetType = 'autosnippet' }, {
    t 'Toronto ',
  }),
  s({ trig = 'sydney ', snippetType = 'autosnippet' }, {
    t 'Sydney ',
  }),
  s({ trig = 'mexico city ', snippetType = 'autosnippet' }, {
    t 'Mexico City ',
  }),
  s({ trig = 'johannesburg ', snippetType = 'autosnippet' }, {
    t 'Johannesburg ',
  }),
  s({ trig = 'seoul ', snippetType = 'autosnippet' }, {
    t 'Seoul ',
  }),

  -- most common languages
  s({ trig = 'english ', snippetType = 'autosnippet' }, {
    t 'English ',
  }),
  s({ trig = 'french ', snippetType = 'autosnippet' }, {
    t 'French ',
  }),
  s({ trig = 'german ', snippetType = 'autosnippet' }, {
    t 'German ',
  }),
  s({ trig = 'italian ', snippetType = 'autosnippet' }, {
    t 'Italian ',
  }),
  s({ trig = 'spanish ', snippetType = 'autosnippet' }, {
    t 'Spanish ',
  }),
  s({ trig = 'chinese ', snippetType = 'autosnippet' }, {
    t 'Chinese ',
  }),
  s({ trig = 'russian ', snippetType = 'autosnippet' }, {
    t 'Russian ',
  }),
  s({ trig = 'japanese ', snippetType = 'autosnippet' }, {
    t 'Japanese ',
  }),
  s({ trig = 'hindi ', snippetType = 'autosnippet' }, {
    t 'Hindi ',
  }),
  s({ trig = 'portuguese ', snippetType = 'autosnippet' }, {
    t 'Portuguese ',
  }),
  s({ trig = 'arabic ', snippetType = 'autosnippet' }, {
    t 'Arabic ',
  }),
  s({ trig = 'bengali ', snippetType = 'autosnippet' }, {
    t 'Bengali ',
  }),
  s({ trig = 'punjabi ', snippetType = 'autosnippet' }, {
    t 'Punjabi ',
  }),

  -- Common historic events
  s({ trig = 'ww1 ', snippetType = 'autosnippet' }, {
    t 'WW1 ',
  }),
  s({ trig = 'ww2 ', snippetType = 'autosnippet' }, {
    t 'WW2 ',
  }),
  s({ trig = 'cold war ', snippetType = 'autosnippet' }, {
    t 'Cold War ',
  }),
  s({ trig = 'vietnam war ', snippetType = 'autosnippet' }, {
    t 'Vietnam War ',
  }),
  s({ trig = 'korean war ', snippetType = 'autosnippet' }, {
    t 'Korean War ',
  }),
  s({ trig = 'civil war ', snippetType = 'autosnippet' }, {
    t 'Civil War ',
  }),
  s({ trig = 'american revolution ', snippetType = 'autosnippet' }, {
    t 'American Revolution ',
  }),
  s({ trig = 'french revolution ', snippetType = 'autosnippet' }, {
    t 'French Revolution ',
  }),
  s({ trig = 'industrial revolution ', snippetType = 'autosnippet' }, {
    t 'Industrial Revolution ',
  }),
  s({ trig = 'great depression ', snippetType = 'autosnippet' }, {
    t 'Great Depression ',
  }),
  s({ trig = 'renaissance ', snippetType = 'autosnippet' }, {
    t 'Renaissance ',
  }),
  s({ trig = 'middle ages ', snippetType = 'autosnippet' }, {
    t 'Middle Ages ',
  }),
  s({ trig = 'ancient rome ', snippetType = 'autosnippet' }, {
    t 'Ancient Rome ',
  }),
  s({ trig = 'ancient greece ', snippetType = 'autosnippet' }, {
    t 'Ancient Greece ',
  }),
}
