{...}: {
  flake = {
    nixosModules.ai-services = {
      lib,
      username,
      impermanence,
      config,
      pkgs,
      ...
    }: let
      autoRouterConfig-1 = pkgs.writeText "litellm-router.json" (
        builtins.toJSON {
          encoder_type = "litellm";
          encoder_name = "nvidia_nim/nvidia/nv-embedqa-mistral-7b-v2";
          routes = [
            {
              name = "code";
              utterances = [
                "write a function in [language]"
                "debug this code"
                "explain what this script does"
                "CODE"
              ];
              description = "coding tasks";
              score_threshold = 0.5;
              function_schemas = null;
              llm = null;
              metadata = {};
            }
            {
              name = "general";
              utterances = [
                "what is this"
                "summarize this"
                "translate this"
                "explain this"
                "GENERAL"
              ];
              description = "general queries";
              score_threshold = 0.5;
              function_schemas = null;
              llm = null;
              metadata = {};
            }
            {
              name = "Polski";
              utterances = [
                "co to jest"
                "skróć"
                "przetłumacz"
                "wytłumacz to"
                "Cześć"
              ];
              description = "polish language";
              score_threshold = 0.5;
              function_schemas = null;
              llm = null;
              metadata = {};
            }
            {
              name = "fast";
              utterances = [
                "do it fast"
                "ASAP"
              ];
              description = "coding tasks";
              score_threshold = 0.3;
              function_schemas = null;
              llm = null;
              metadata = {};
            }
          ];
        }
      );
      domain = "iameasytoremember.duckdns.org";
    in {
      custom.web-expose.routers = {
        litellm = {
          subdomain = "ai-api";
          port = 4000;
          host = "127.0.0.1";
          public = true;
          auth = "bypass";
          oidc = {
            client_id = "litellm";
            redirect_uris = [
              "https://ai-api.${domain}/auth/callback"
            ];
            client_secret_hash_file = config.sops.secrets."litellm/oidc-client-secret-hash".path;
          };
        };
        librechat = {
          subdomain = "chat";
          port = 3080;
          host = "127.0.0.1";
          public = true;
          auth = "bypass";
          oidc = {
            client_id = "librechat";
            redirect_uris = [
              "https://chat.${domain}/oauth/openid/callback"
            ];
            client_secret_hash_file = config.sops.secrets."librechat/oidc-client-secret-hash".path;
          };
        };
        vane = {
          subdomain = "search-ai";
          port = 5555;
          host = "127.0.0.1";
          public = true;
          auth = "two_factor";
          subjects = ["group:service-users"];
        };
      };

      sops.secrets = {
        "litellm/env" = {
          owner = "litellm";
        };
        "litellm/oidc-client-secret" = {
          owner = "litellm";
        };
        "litellm/oidc-client-secret-hash" = {
          owner = "authelia-main";
          group = "authelia-main";
        };

        "librechat/env" = {
          owner = "librechat";
        };

        "librechat/oidc-client-secret-hash" = {
          owner = "authelia-main";
          group = "authelia-main";
        };

        "librechat/meili-master-key" = {
          owner = "meilisearch";
        };
      };

      services.litellm = {
        # We are waiting for litellm to implement observation decay for adaptive routers, see https://docs.litellm.ai/docs/adaptive_router
        enable = true;
        port = 4000;
        host = "127.0.0.1";
        environmentFile = config.sops.secrets."litellm/env".path;

        settings = {
          litellm_settings = {
            drop_params = true;
            request_timeout = 30;
            num_retries = 3;
          };
          general_settings = {
            disable_master_key_return = true;
            ui = false;
            master_key = "os.environ/LITELLM_MASTER_KEY";

            search_tools = [
              {
                search_tool_name = "searxng-search";
                search_provider = "searxng";
                api_base = "http://127.0.0.1:8889";
              }
            ];
            websearch_interception_params = {
              enabled_providers = [
                "groq"
                "gemini"
                "mistral"
                "cohere"
                "cerebras"
                "openrouter"
                "nvidia_nim"
                "zai"
              ];
              search_tool_name = "searxng-search";
            };
            litellm_settings = {
              callbacks = ["websearch_interception"];
            };
          };
          router_settings = {
            content_policy_fallbacks = [
              {
                "*" = ["uncensored"];
              }
            ];
            routing_strategy = "simple-shuffle";
            num_retries = 2;
            timeout = 120;
            optional_pre_call_checks = ["enforce_model_rate_limits"];
            routing_groups = [
              {
                group_name = "latency-critical";
                models = [
                  "embed"
                  "code-completion"
                  "fast"
                  "general"
                ];
                routing_strategy = "latency-based-routing";
                routing_strategy_args = {
                  ttl = 3600;
                };
              }
            ];
          };

          model_list = [
            {
              model_name = "groq/*";
              litellm_params = {
                model = "groq/*";
                api_key = "os.environ/GROQ_API_KEY";
              };
            }
            {
              model_name = "gemini/*";
              litellm_params = {
                model = "gemini/*";
                api_key = "os.environ/GEMINI_API_KEY";
              };
            }
            {
              model_name = "mistral/*";
              litellm_params = {
                model = "mistral/*";
                api_key = "os.environ/MISTRAL_API_KEY";
              };
            }
            {
              model_name = "cohere/*";
              litellm_params = {
                model = "cohere/*";
                api_key = "os.environ/COHERE_API_KEY";
              };
            }
            {
              model_name = "cerebras/*";
              litellm_params = {
                model = "cerebras/*";
                api_key = "os.environ/CEREBRAS_API_KEY";
              };
            }
            {
              model_name = "openrouter/*";
              litellm_params = {
                model = "openrouter/*";
                api_key = "os.environ/OPENROUTER_API_KEY";
              };
            }
            {
              model_name = "nvidia_nim/*";
              litellm_params = {
                model = "nvidia_nim/*";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
              };
            }
            {
              model_name = "zai/*";
              litellm_params = {
                model = "zai/*";
                api_key = "os.environ/ZAI_API_KEY";
              };
            }

            # https://cloud.cerebras.ai/platform/models
            {
              model_name = "fast/GPT-OSS-120b";
              litellm_params = {
                model = "cerebras/gpt-oss-120b";
                api_key = "os.environ/CEREBRAS_API_KEY";
                rpm = 5;
                rpd = 2400;
                tpm = 30000;
                tpd = 1000000;
                order = 1;
              };
            }
            {
              model_name = "fast/glm-4.7";
              litellm_params = {
                model = "cerebras/zai-glm-4.7";
                api_key = "os.environ/CEREBRAS_API_KEY";
                rpm = 5;
                rpd = 2400;
                tpm = 30000;
                tpd = 1000000;
              };
            }

            # https://console.groq.com/docs/rate-limits
            {
              model_name = "fast/GPT-OSS-120b";
              litellm_params = {
                model = "groq/openai/gpt-oss-120b";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 1000;
                tpm = 8000;
                tpd = 200000;
                order = 2;
              };
            }
            {
              model_name = "fast/llama-4-scout";
              litellm_params = {
                model = "groq/meta-llama/llama-4-scout-17b-16e-instruct";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 1000;
                tpm = 30000;
                tpd = 500000;
              };
            }
            {
              model_name = "groq/compound";
              litellm_params = {
                model = "groq/compound";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 250;
                tpm = 70000;
                order = 1;
              };
            }
            {
              model_name = "groq/compound";
              litellm_params = {
                model = "groq/compound-mini";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 250;
                tpm = 70000;
                order = 2;
              };
            }
            {
              model_name = "prompt-guard-llama-2";
              litellm_params = {
                model = "groq/meta-llama/llama-prompt-guard-2-86m";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 14400;
                tpm = 15000;
                tpd = 500000;
              };
            }

            # https://admin.mistral.ai/plateforme/limits
            {
              model_name = "code-completion-codestral";
              litellm_params = {
                model = "mistral/codestral-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 120;
                tpm = 625000;
              };
            }
            {
              model_name = "codestral-embed";
              litellm_params = {
                model = "mistral/codestral-embed";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 4000000;
              };
            }
            {
              model_name = "mistral-small";
              litellm_params = {
                model = "mistral/mistral-small-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 50;
                tpm = 50000;
              };
            }
            {
              model_name = "mistral-medium";
              litellm_params = {
                model = "mistral/mistral-medium-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
              };
            }
            {
              model_name = "mistral-large";
              litellm_params = {
                model = "mistral/mistral-large-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
              };
            }
            {
              model_name = "mistral-OCR";
              litellm_params = {
                model = "mistral/mistral-ocr-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
              };
            }
            {
              model_name = "mistral-moderation";
              litellm_params = {
                model = "mistral/mistral-moderation-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 100;
                tpm = 50000;
              };
            }
            {
              model_name = "mistral-embed";
              litellm_params = {
                model = "mistral/mistral-embed";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 100;
                tpm = 50000;
              };
            }
            {
              model_name = "devstral";
              litellm_params = {
                model = "mistral/devstral-medium-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 100;
                tpm = 50000;
              };
            }

            # https://openrouter.ai/chat
            {
              model_name = "minimax-m2.5";
              litellm_params = {
                model = "openrouter/minimax/minimax-m2.5:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "deepseek-v4-flash";
              litellm_params = {
                model = "openrouter/deepseek/deepseek-v4-flash:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "nemotron-120b";
              litellm_params = {
                model = "openrouter/nvidia/nemotron-3-super-120b-a12b:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "nemotron-30b";
              litellm_params = {
                model = "openrouter/nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "qwen-coder-480b";
              litellm_params = {
                model = "openrouter/qwen/qwen3-coder:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "poolside-m1";
              litellm_params = {
                model = "openrouter/poolside/laguna-m.1:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "gemma4-31b";
              litellm_params = {
                model = "openrouter/google/gemma-4-31b-it:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "gemma4-26b";
              litellm_params = {
                model = "openrouter/google/gemma-4-26b-a4b-it:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "uncensored";
              litellm_params = {
                model = "openrouter/cognitivecomputations/dolphin-mistral-24b-venice-edition:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "qwen3-80b";
              litellm_params = {
                model = "openrouter/qwen/qwen3-next-80b-a3b-instruct:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }
            {
              model_name = "random";
              litellm_params = {
                model = "openrouter/openrouter/free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
              };
            }

            # https://docs.cohere.com/docs/rate-limits
            {
              model_name = "command-a";
              litellm_params = {
                model = "cohere/command-a-reasoning-08-2025";
                api_key = "os.environ/COHERE_API_KEY";
                rpm = 20;
              };
            }
            {
              model_name = "command-a-translate";
              litellm_params = {
                model = "cohere/command-a-translate-08-2025";
                api_key = "os.environ/COHERE_API_KEY";
                rpm = 20;
              };
            }
            {
              model_name = "cohere-embed";
              litellm_params = {
                model = "cohere/embed-v4.0";
                api_key = "os.environ/COHERE_API_KEY";
                rpm = 2000;
              };
            }

            # https://aistudio.google.com/app/rate-limit
            {
              model_name = "gemma4-31b";
              litellm_params = {
                model = "gemini/gemma-4-31b-it";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 1500;
              };
            }
            {
              model_name = "gemma4-26b";
              litellm_params = {
                model = "gemini/gemma-4-26b-a4b-it";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 1500;
              };
            }
            {
              model_name = "gemini-3.1-flash-lite";
              litellm_params = {
                model = "gemini/gemini-3.1-flash-lite";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 500;
                tpm = 250000;
              };
            }
            {
              model_name = "gemini-live";
              litellm_params = {
                model = "gemini/gemini-3.1-flash-live-preview";
                api_key = "os.environ/GEMINI_API_KEY";
                tpm = 65000;
              };
            }
            {
              model_name = "gemini-3-flash";
              litellm_params = {
                model = "gemini/gemini-3-flash-preview";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 5;
                rpd = 20;
                tpm = 250000;
              };
            }
            {
              model_name = "gemini-embed";
              litellm_params = {
                model = "gemini/gemini-embedding-2";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 100;
                rpd = 1000;
                tpm = 30000;
              };
            }

            # https://docs.z.ai/guides/overview/pricing
            {
              model_name = "glm-4.7-flash";
              litellm_params = {
                model = "zai/glm-4.7-flash";
                api_key = "os.environ/ZAI_API_KEY";
              };
            }

            # https://build.nvidia.com/models
            {
              model_name = "code-completion-starcoder";
              litellm_params = {
                model = "nvidia_nim/bigcode/starcoder2-15b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "code-completion-deepseek";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-coder-6.7b-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "deepseek-v4-flash";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "deepseek-v4-pro";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-pro";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "gemma4-31b";
              litellm_params = {
                model = "nvidia_nim/google/gemma-4-31b-it";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "prompt-guard-llama-4";
              litellm_params = {
                model = "nvidia_nim/meta/llama-guard-4-12b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "llama-4-maverick";
              litellm_params = {
                model = "nvidia_nim/meta/llama-4-maverick-17b-128e-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "phi-4";
              litellm_params = {
                model = "nvidia_nim/microsoft/phi-4-multimodal-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "minimax-m2.7";
              litellm_params = {
                model = "nvidia_nim/minimaxai/minimax-m2.7";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "kimi-k2.6";
              litellm_params = {
                model = "nvidia_nim/moonshotai/kimi-k2.6";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "nemotron-120b";
              litellm_params = {
                model = "nvidia_nim/nvidia/nemotron-3-super-120b-a12b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "nemotron-30b";
              litellm_params = {
                model = "nvidia_nim/nvidia/nemotron-3-nano-omni-30b-a3b-reasoning";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "nvidia-embed";
              litellm_params = {
                model = "nvidia_nim/nvidia/nv-embedqa-mistral-7b-v2";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "qwen-coder-480b";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3-coder-480b-a35b-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "qwen3-80b";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3-next-80b-a3b-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "qwen3.5-122b";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3.5-122b-a10b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "qwen3.5-397b";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3.5-397b-a17b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "step-3.5-flash";
              litellm_params = {
                model = "nvidia_nim/stepfun-ai/step-3.5-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "glm-5";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm5";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }
            {
              model_name = "glm-5.1";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm-5.1";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
              };
            }

            # embedding models
            {
              model_name = "embed";
              litellm_params = {
                model = "nvidia_nim/nvidia/nv-embedqa-mistral-7b-v2";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "embed";
              litellm_params = {
                model = "gemini/gemini-embedding-2";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 100;
                rpd = 1000;
                tpm = 30000;
                order = 2;
              };
            }
            {
              model_name = "embed";
              litellm_params = {
                model = "cohere/embed-v4.0";
                api_key = "os.environ/COHERE_API_KEY";
                rpm = 2000;
                order = 3;
              };
            }
            {
              model_name = "embed";
              litellm_params = {
                model = "mistral/mistral-embed";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 100;
                tpm = 50000;
                order = 4;
              };
            }

            # code completion models
            {
              model_name = "code-completion";
              litellm_params = {
                model = "mistral/codestral-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 120;
                tpm = 625000;
                order = 1;
              };
            }
            {
              model_name = "code-completion";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-coder-6.7b-instruct";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 2;
              };
            }
            {
              model_name = "code-completion";
              litellm_params = {
                model = "nvidia_nim/bigcode/starcoder2-15b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 3;
              };
            }

            # code generation models
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/moonshotai/kimi-k2.6";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm-5.1";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm5";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/minimaxai/minimax-m2.7";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3.5-397b-a17b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-pro";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "openrouter/minimax/minimax-m2.5:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 7;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "mistral/mistral-medium-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
                order = 8;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "openrouter/deepseek/deepseek-v4-flash:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 9;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 9;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/stepfun-ai/step-3.5-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 10;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "openrouter/google/gemma-4-31b-it:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 11;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "gemini/gemma-4-31b-it";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 1500;
                order = 11;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/google/gemma-4-31b-it";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 11;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "openrouter/nvidia/nemotron-3-super-120b-a12b:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 12;
              };
            }
            {
              model_name = "code";
              litellm_params = {
                model = "nvidia_nim/nvidia/nemotron-3-super-120b-a12b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 12;
              };
            }

            # general purpose models
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/moonshotai/kimi-k2.6";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/minimaxai/minimax-m2.7";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm-5.1";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3.5-397b-a17b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-pro";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 1;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "openrouter/minimax/minimax-m2.5:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 4;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/z-ai/glm5";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 5;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "mistral/mistral-medium-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
                order = 8;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "openrouter/google/gemma-4-31b-it:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 9;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "gemini/gemma-4-31b-it";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 1500;
                order = 9;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/google/gemma-4-31b-it";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 9;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/stepfun-ai/step-3.5-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 10;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "openrouter/deepseek/deepseek-v4-flash:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 11;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/deepseek-ai/deepseek-v4-flash";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 11;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "openrouter/nvidia/nemotron-3-super-120b-a12b:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 12;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "nvidia_nim/nvidia/nemotron-3-super-120b-a12b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 12;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "gemini/gemini-3.1-flash-lite";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 500;
                tpm = 250000;
                order = 13;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "cerebras/gpt-oss-120b";
                api_key = "os.environ/CEREBRAS_API_KEY";
                rpm = 5;
                rpd = 2400;
                tpm = 30000;
                tpd = 1000000;
                order = 14;
              };
            }
            {
              model_name = "general";
              litellm_params = {
                model = "groq/openai/gpt-oss-120b";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 1000;
                tpm = 8000;
                tpd = 200000;
                order = 14;
              };
            }

            # Speed focused routing
            {
              model_name = "fast";
              litellm_params = {
                model = "cerebras/gpt-oss-120b";
                api_key = "os.environ/CEREBRAS_API_KEY";
                rpm = 5;
                rpd = 2400;
                tpm = 30000;
                tpd = 1000000;
                order = 2;
              };
            }
            {
              model_name = "fast";
              litellm_params = {
                model = "cerebras/zai-glm-4.7";
                api_key = "os.environ/CEREBRAS_API_KEY";
                rpm = 5;
                rpd = 2400;
                tpm = 30000;
                tpd = 1000000;
                order = 1;
              };
            }
            {
              model_name = "fast";
              litellm_params = {
                model = "groq/openai/gpt-oss-120b";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 1000;
                tpm = 8000;
                tpd = 200000;
                order = 3;
              };
            }
            {
              model_name = "fast";
              litellm_params = {
                model = "groq/meta-llama/llama-4-scout-17b-16e-instruct";
                api_key = "os.environ/GROQ_API_KEY";
                rpm = 30;
                rpd = 1000;
                tpm = 30000;
                tpd = 500000;
                order = 4;
              };
            }

            # Polish language models, for my family
            {
              model_name = "Polski";
              litellm_params = {
                model = "gemini/gemini-3.1-flash-lite";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 500;
                tpm = 250000;
                order = 1;
              };
            }
            {
              model_name = "Polski";
              litellm_params = {
                model = "mistral/mistral-medium-latest";
                api_key = "os.environ/MISTRAL_API_KEY";
                rpm = 60;
                tpm = 50000;
                order = 2;
              };
            }
            {
              model_name = "Polski";
              litellm_params = {
                model = "openrouter/google/gemma-4-31b-it:free";
                api_key = "os.environ/OPENROUTER_API_KEY";
                rpm = 20;
                rpd = 1000;
                order = 3;
              };
            }
            {
              model_name = "Polski";
              litellm_params = {
                model = "gemini/gemma-4-31b-it";
                api_key = "os.environ/GEMINI_API_KEY";
                rpm = 15;
                rpd = 1500;
                order = 3;
              };
            }
            {
              model_name = "Polski";
              litellm_params = {
                model = "nvidia_nim/google/gemma-4-31b-it";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 3;
              };
            }
            {
              model_name = "Polski";
              litellm_params = {
                model = "nvidia_nim/qwen/qwen3.5-397b-a17b";
                api_key = "os.environ/NVIDIA_NIM_API_KEY";
                rpm = 40;
                order = 4;
              };
            }

            # Add a complexity based router
            # https://docs.litellm.ai/docs/proxy/auto_routing#complexity-router

            {
              model_name = "auto-router";
              litellm_params = {
                model = "auto_router/auto_router_1";
                auto_router_config_path = "${autoRouterConfig-1}";
                auto_router_default_model = "general";
                auto_router_embedding_model = "embed";
              };
            }
          ];
        };

        meilisearch.masterKeyFile = config.sops.secrets."librechat/meili-master-key".path;

        librechat = {
          enable = true;
          enableLocalDB = true;
          meilisearch.enable = true;

          credentialsFile = config.sops.secrets."librechat/env".path;

          env = {
            HOST = "127.0.0.1";
            PORT = 3080;

            ALLOW_REGISTRATION = true;
            ALLOW_EMAIL_LOGIN = false;
            ALLOW_SOCIAL_LOGIN = true;
            OPENID_ISSUER = "https://auth.${domain}";
            OPENID_CLIENT_ID = "librechat";
            OPENID_CALLBACK_URL = "https://chat.${domain}/oauth/openid/callback";
            OPENID_SCOPE = "openid profile email";
            OPENID_BUTTON_LABEL = "Login with Authelia";

            LITELLM_BASE_URL = "http://127.0.0.1:4000";
          };

          settings = {
            version = "1.3.11";
            cache = true;

            search = {
              enabled = true;
              provider = "searxng";
              searchQuery = {
                url = "http://127.0.0.1:8889";
              };
            };

            endpoints = {
              custom = [
                {
                  name = "LiteLLM";
                  apiKey = "\${LITELLM_API_KEY}";
                  baseURL = "http://127.0.0.1:4000/v1";
                  models = {
                    default = [
                      "general"
                      "fast"
                      "code"
                      "Polski"
                      "auto-router"
                    ];
                    fetch = true;
                  };
                  titleConvo = true;
                  titleModel = "general";
                  dropParams = ["stop"];
                  modelDisplayLabel = "LiteLLM";
                }
              ];
            };

            interface = {
            };
          };
        };
      };
      systemd = {
        services.librechat = {
          after = ["mongodb.service"];
          wants = ["mongodb.service"];
        };
        tmpfiles.rules = ["d /var/lib/vane 0755 root root -"];
      };

      # add LiteLLM as an OpenAI-compatible provider:
      #   API URL: http://host.containers.internal:4000
      #   API Key: LITELLM_MASTER_KEY
      virtualisation.oci-containers.containers.vane = {
        # renovate: versioning=docker
        image = "itzcrazykns1337/vane:slim-1.12.2";
        ports = ["127.0.0.1:5555:3000"];
        volumes = ["/var/lib/vane:/home/vane/data"];
        environment = {
          SEARXNG_API_URL = "http://host.containers.internal:8889";
        };
        extraOptions = ["--add-host=host.containers.internal:host-gateway"];
      };
    };
  };
}
