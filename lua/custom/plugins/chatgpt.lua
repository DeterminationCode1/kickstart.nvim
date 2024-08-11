-- repo https://github.com/jackMort/ChatGPT.nvim
-- Description: ChatGPT.nvim allows you to chat with GPT-3 directly from Neovim and easily passe text back and forth.
--
-- ==== SETUP ====
-- Get an OpenAi API key from https://platform.openai.com/api-keys and store it in [[pass - ]] cli-tool.
--
-- IMPORTANT: set a monthly budget limit in the OpenAI dashboard to avoid unexpected costs: https://platform.openai.com/settings/organization/limits
--
-- See openai api pricing: https://openai.com/api/pricing/
--
-- Environment secrets:
--
-- At The Moment, you set the API key in the environment variable $OPENAI_API_KEY in your dotfiles/personal/env file:
-- # ========= Me: optional environment variables. =========
-- # Providing the OpenAI API key via an environment variable is dangerous, as it leaves the API key easily readable by any process that can access the environment variables of other processes. In addition, it encourages the user to store the credential in clear-text in a configuration file.

-- # NOTES maybe it would be more secrue to reenter the pass phrase every time the API key is needed by the `api_key_cmd` option for the plugin
-- # but it gets tiresome and `pass` prompt is not automatically triggerd like 1password cli so its even more cumbersome
--
-- # As an alternative to providing the API key via the OPENAI_API_KEY environment variable, the user is encouraged to use the api_key_cmd configuration option. The api_key_cmd configuration option takes a string, which is executed at startup, and whose output is used as the API key.
-- export OPENAI_API_KEY=$(pass show openai.com/api_key_chatgptneovim_2024-08-01_pure)
-- FIX: you can prinout out the environment wit `env` command in the terminal anytime and. that is dangerous.
-- It'S a tradeoff between security and convenience.

return {
  'jackMort/ChatGPT.nvim',
  event = 'VeryLazy',
  config = function()
    -- WARNING: "Dreams of Code" ueses his own async fork version to speed up startup time.
    --  You could also use a environment var $OPENAI_API_KEY. https://github.com/jackMort/ChatGPT.nvim?tab=readme-ov-file#installation
    require('chatgpt').setup {
      -- NOTES using gpg encryption to manage secrets is the official recommended way.
      -- See https://github.com/jackMort/ChatGPT.nvim?tab=readme-ov-file#secrets-management
      -- FIX: Not sure if using `| head -and 1` is secure. The official docs would suggest to ues "pass show apikey"
      --   You would just need to exclud the oth fileds / information in the api pass file.
      --   There is no option to only get the first line in the pass cli-tool.
      --  See debate pass forum https://lists.zx2c4.com/pipermail/password-store/2017-August/003017.html
      -- api_key_cmd = 'pass show openai.com/api_key_chatgptneovim_2024-08-01_pure',
      -- api_key_cmd = 'pass show openai.com/api_key_chatgptneovim_2024-08-01 | head -n 1',
    }
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim',
    'nvim-telescope/telescope.nvim',
  },
}
