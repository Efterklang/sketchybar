-- NORD — tema de la barra
-- Fuente de verdad: Nord (polar night #2E3440, frost #88C0D0, snow storm #D8DEE9).
-- Filosofía: un solo acento frío (#88C0D0) para los elementos activos; el resto
-- en grises azulados de polar night. Lo funcional conserva su color: rojo para
-- errores, azul para marcas de chat, verde para estado correcto.
return {
  -- ── Acento único: frost, solo elementos activos ──
  mauve = 0xff88c0d0, -- workspace activo (icon)
  lavender = 0xff88c0d0, -- workspace activo (label), toggles, knob del slider
  pink = 0xff88c0d0, -- reservado, mismo acento
  teal = 0xff88c0d0, -- reservado, mismo acento

  -- ── Decorativo → grises (nada de color estático) ──
  peach = 0xff4c566a, -- brew parcial / batería media / gráficas
  flamingo = 0xff4c566a, -- wifi conectado (solo avisa en rojo cuando falla)
  yellow = 0xff4c566a, -- volumen / cpu / brew pendiente
  green = 0xff4c566a, -- batería ok / brew al día / música

  -- ── Funcionales (información real) ──
  red = 0xffbf616a,
  maroon = 0xffbf616a,
  blue = 0xff81a1c1,
  sky = 0xff5e81ac,
  sapphire = 0xff5e81ac,
  rosewater = 0xffbf616a,

  -- ── Jerarquía de grises fríos (Nord) ──
  text = 0xffd8dee9,
  subtext1 = 0xccd8dee9,
  subtext0 = 0x99d8dee9,
  grey = 0xff7f8ba0,
  overlay2 = 0xff6b7688,
  overlay1 = 0xff5b6678,
  overlay0 = 0xff4c566a,
  surface2 = 0xff434c5e,
  surface1 = 0xff3b4252,
  surface0 = 0xff363f4d, -- pastilla del workspace activo

  -- ── Lienzos Nord (opaco) ──
  base = 0xff2e3440,
  mantle = 0xff292f3b,
  crust = 0xff242a35,
}
