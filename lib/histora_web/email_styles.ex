defmodule HistoraWeb.EmailStyles do

  def utility_classes do
    (
      build_typography() ++
      build_margin_padding_size() ++
      build_colors() ++
      build_borders()
    )
    |> Enum.concat([
      ".block {display: block;}",
      ".inline-block {display: inline-block;}",
      ".inline {display: inline;}",
      ".clear-both {clear: both;}",
    ])
    |> Enum.join()
  end

  def build_typography do
    [
      ".font-thin {font-weight: 100;}",
      ".font-extralight {font-weight: 200;}",
      ".font-light {font-weight: 300;}",
      ".font-normal {font-weight: 400;}",
      ".font-medium {font-weight: 500;}",
      ".font-semibold {font-weight: 600;}",
      ".font-bold {font-weight: 700;}",
      ".font-extrabold {font-weight: 800;}",
      ".font-black {font-weight: 900;}",

      ".text-xs {font-size: 12px;line-height: 16px;}",
      ".text-sm {font-size: 14px;line-height: 20px;}",
      ".text-base {font-size: 16px;line-height: 24px;}",
      ".text-lg {font-size: 18px;line-height: 28px;}",
      ".text-xl {font-size: 20px;line-height: 28px;}",
      ".text-2xl {font-size: 24px;line-height: 32px;}",
      ".text-3xl {font-size: 30px;line-height: 36px;}",
      ".text-4xl {font-size: 36px;line-height: 40px;}",
      ".text-5xl {font-size: 48px;line-height: 1;}",
      ".text-left {text-align: left;}",
      ".text-right {text-align: right;}",
      ".text-center {text-align: center;}",
      ".text-justify {text-align: justify;}",

      ".uppercase { text-transform: uppercase; }",
      ".lowercase { text-transform: lowercase; }",
      ".capitalize { text-transform: capitalize; }",
      ".normal-case { text-transform: none; }",

      ".underline { text-decoration: underline; }",
      ".line-through { text-decoration: line-through; }",
      ".no-underline { text-decoration: none; }",

      ~s(.font-sans { font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"; }),
      ~s(.font-serif { font-family: ui-serif, Georgia, Cambria, "Times New Roman", Times, serif; }),
      ~s(.no-underline { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }),

      ".antialiased {-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;}"
    ]
  end

  @steps %{
    "0" => "0px",
    "1" => "4px",
    "2" => "8px",
    "3" => "12px",
    "4" => "16px",
    "5" => "20px",
    "6" => "24px",
    "8" => "32px",
    "10" => "40px",
    "12" => "48px",
    "16" => "64px",
    "20" => "80px",
    "24" => "96px",
    "28" => "112px",
    "32" => "128px",
  }
  @base_classes %{
    "m" => "margin",
    "mt" => "margin-top",
    "mb" => "margin-bottom",
    "mr" => "margin-right",
    "ml" => "margin-left",
    "p" => "padding",
    "pt" => "padding-top",
    "pb" => "padding-bottom",
    "pr" => "padding-right",
    "pl" => "padding-left",
    "h" => "height",
    "w" => "width",
  }
  def build_margin_padding_size() do
    base_class_keys = Map.keys(@base_classes)
    step_keys = Map.keys(@steps)
    Enum.reduce(base_class_keys, [], fn base_class_key, list ->
      list ++ Enum.map(step_keys, fn step_key ->
        ".#{base_class_key}-#{step_key} {#{Map.get(@base_classes, base_class_key)}: #{Map.get(@steps, step_key)};}"
      end)
    end)
    |> Enum.concat([
      ".mx-auto {0 auto !important;}",
      ".w-full {width: 100%;}",
      ".h-full {height: 100%;}",
      ".max-w-sm {max-width: 384px;}",
      ".max-w-md {max-width: 448px;}",
      ".max-w-lg {max-width: 512px;}",
      ".max-w-xl {max-width: 576px;}",
      ".max-w-2xl {max-width: 672px;}",
    ])
    |> List.flatten()
  end

  @colors %{
    "primary" => "#2b9455",
    "dark-primary" => "#1d663a",
    "light-primary" => "#62ea98",
    "darkest-grey" => "#181818",
    "dark-grey" => "#6b6b6b",
    "grey" => "#9E9E9E",
    "grey-ish" => "#e0e0e0",
    "light-grey" => "#dedede",
    "really-light-grey" => "#f2f3f4",
    "black" => "#000000",
    "white" => "#ffffff",
    "slate" => "#121212",
    "yellow" => "#FFD700",
    "orange" => "#FFAC1C",
    "blue" => "#0096FF",
    "red" => "#CC0000"
  }

  @base_classes %{
    "border" => "border-color",
    "text" => "color",
    "bg" => "background-color",
  }
  def build_colors() do
    base_class_keys = Map.keys(@base_classes)
    color_keys = Map.keys(@colors)

    Enum.reduce(base_class_keys, [], fn base_class_key, list ->
      list ++ Enum.map(color_keys, fn color_key ->
        ".#{base_class_key}-#{color_key} {#{Map.get(@base_classes, base_class_key)}: #{Map.get(@colors, color_key)};}"
      end)
    end)
    |> List.flatten()
  end

  @base_classes %{
    "" => "1px",
    "-0" => "0px",
    "-2" => "2px",
    "-4" => "4px",
    "-8" => "8px",
  }
  @variants %{
    "border" => "border-width",
    "border-t" => "border-top-width",
    "border-b" => "border-bottom-width",
    "border-r" => "border-right-width",
    "border-l" => "border-left-width",
  }
  def build_borders do
    base_class_keys = Map.keys(@base_classes)
    variants = Map.keys(@variants)

    [
      ".rounded { border-radius: 4px; }",
      ".rounded-md { border-radius: 6px; }",
      ".rounded-lg { border-radius: 8px; }",
      ".rounded-xl { border-radius: 12px; }",
      ".rounded-2xl { border-radius: 18px; }",
    ] ++ Enum.map(variants, fn variant ->
      Enum.map(base_class_keys, fn width ->
        ".#{variant}#{width} {#{Map.get(@variants, variant)}: #{Map.get(@base_classes, width)};}"
      end)
    end)
    |> Enum.concat([
      ".border-solid {border-style: solid; border-width: 1px;}",
      ".border-dashed {border-style: dashed;}",
      ".border-dotted {border-style: dotted;}",
      ".border-double {border-style: double;}",
      ".border-none {border-style: none;}",
    ])
    |> Enum.concat([
      ".flex {display: flex;}",
      ".space {margin-top: 1em; margin-bottom: 1em;}",
      "a { all: unset; } "
    ])
    |> List.flatten()
  end
end
