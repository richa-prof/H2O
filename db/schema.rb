# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "abilidade_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "abilidade_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
  end

  create_table "abilidades", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "adm_usuario_perfis", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 50, null: false
  end

  create_table "adm_usuarios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "adm_usuario_perfil_id", null: false
    t.string "nome", limit: 50, null: false
    t.string "email", limit: 150, null: false
    t.string "usuario", limit: 20, null: false
    t.string "senha", null: false, comment: "pw"
    t.string "old_hash"
    t.text "config"
    t.text "produtos"
    t.string "base", limit: 25
    t.float "meta"
    t.string "whats", limit: 20
    t.string "btms_usuario", limit: 50
    t.string "btms_senha", limit: 50
    t.string "tela_de_trabalho", limit: 50
    t.string "voucher_usuario", limit: 50
    t.string "voucher_senha", limit: 50
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "email", unique: true
    t.index ["email"], name: "index_adm_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_adm_usuarios_on_reset_password_token", unique: true
    t.index ["usuario"], name: "usuario", unique: true
  end

  create_table "almoco_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "almoco_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
    t.string "nome_menu", limit: 50
  end

  create_table "almocos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
  end

  create_table "banner_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "banner_id", null: false
    t.string "locale", limit: 10, null: false
    t.string "titulo", null: false
    t.string "subtitulo", null: false
    t.string "texto"
    t.string "link"
  end

  create_table "banners", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "tipo", limit: 100, default: ""
    t.string "imagem_fundo", default: ""
    t.string "imagem", default: ""
    t.string "link"
    t.integer "ordem"
  end

  create_table "block_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "block_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
  end

  create_table "blocks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 25, null: false
    t.index ["nome"], name: "nome_UNIQUE", unique: true
  end

  create_table "bring_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "bring_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
    t.index ["bring_id"], name: "index_bring_locales_on_bring_id"
    t.index ["locale"], name: "index_bring_locales_on_locale"
  end

  create_table "brings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
    t.string "icon_name", limit: 100
  end

  create_table "carrinho_itens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "carrinho_id", null: false
    t.integer "produto_variacao_id", null: false
    t.integer "produto_subvariacao_id", null: false
    t.integer "qtde", null: false
    t.float "peso"
    t.float "preco_unitario", null: false
    t.float "preco_total", null: false
    t.integer "qtde_adulto"
    t.integer "qtde_crianca"
    t.integer "qtde_crianca2"
    t.float "preco_adulto"
    t.float "preco_crianca"
    t.float "preco_crianca2"
    t.string "subvariacoes"
    t.integer "produto_id"
    t.date "passeio_data"
    t.string "passeio_hora"
    t.string "reserva"
    t.string "tour_system"
    t.index ["carrinho_id"], name: "index_carrinho_itens_on_carrinho_id"
  end

  create_table "carrinho_passageiros", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "carrinho_id", null: false
    t.string "nome", limit: 50, null: false
    t.integer "idade", null: false
    t.string "doc", limit: 20
    t.index ["carrinho_id"], name: "index_carrinho_passageiros_on_carrinho_id"
  end

  create_table "carrinhos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "usuario_id"
    t.integer "endereco_id"
    t.integer "endereco_id2"
    t.string "localizacao"
    t.string "telefone", limit: 20
    t.float "subtotal", default: 0.0, null: false
    t.float "total", default: 0.0, null: false
    t.float "peso"
    t.string "frete_tipo", limit: 45
    t.string "frete_label", limit: 40, default: "test", null: false
    t.integer "frete_prazo", default: 0, null: false
    t.float "frete"
    t.float "desconto"
    t.integer "cupom_id"
    t.string "old_hash"
    t.boolean "abandonado"
    t.datetime "data", null: false
    t.text "historico"
    t.date "start_date"
    t.date "end_date"
    t.index ["usuario_id"], name: "index_carrinhos_on_usuario_id"
  end

  create_table "cart_hotels", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "hotel_id"
    t.string "request_echo_token"
    t.date "start_date"
    t.date "end_date"
    t.integer "adults"
    t.string "children_ages"
    t.integer "number_of_nights"
    t.string "room_type_name"
    t.string "room_selected"
    t.float "sale_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meal"
    t.string "reservation_code"
    t.index ["cart_id"], name: "index_cart_hotels_on_cart_id"
    t.index ["hotel_id"], name: "index_cart_hotels_on_hotel_id"
  end

  create_table "cart_tour_extras", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "cart_id"
    t.integer "tour_extra_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "adults_qty"
    t.integer "children_qty"
    t.integer "children2_qty"
    t.integer "unit_qty"
    t.index ["cart_id"], name: "index_cart_tour_extras_on_cart_id"
    t.index ["tour_extra_id"], name: "index_cart_tour_extras_on_tour_extra_id"
  end

  create_table "categorias", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "categoria_id"
    t.string "nome", limit: 100, null: false
    t.string "link", null: false
    t.boolean "destaque"
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.text "descricao"
    t.integer "ordem"
    t.boolean "exibir_site", default: false
    t.index ["link"], name: "link", unique: true
  end

  create_table "catlocale_categorias", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "catlocale_id", null: false
    t.integer "categoria_id", null: false
  end

  create_table "catlocales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "locale", limit: 10
    t.string "nome", limit: 100, null: false
    t.string "link", default: ""
    t.text "descricao"
    t.string "metatag_titulo"
    t.text "metatag_descricao"
  end

  create_table "cores", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "cor", limit: 100, null: false
    t.string "class", limit: 100, null: false
  end

  create_table "crianca_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "crianca_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
  end

  create_table "criancas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
  end

  create_table "cupons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "chave", null: false
    t.string "tipo", limit: 45, null: false
    t.float "brl"
    t.integer "porcentagem"
    t.integer "limite"
    t.integer "vezes_usado"
    t.integer "usuario_id"
    t.date "vencimento"
    t.string "access_key", limit: 20
    t.index ["chave"], name: "chave", unique: true
  end

  create_table "depoimentos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "status", limit: 15, null: false
    t.string "nome", limit: 100, null: false
    t.string "cidade"
    t.string "email", null: false
    t.string "como_chegou"
    t.text "texto", null: false
    t.datetime "created", null: false
    t.integer "institucionai_id", default: 16
  end

  create_table "duvidas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "titulo", limit: 150, null: false
    t.text "texto", null: false
    t.string "locale", limit: 10
    t.integer "institucionai_id", default: 3
    t.integer "ordem"
  end

  create_table "equipes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 45, null: false
    t.datetime "contratado", null: false
    t.string "imagem", null: false
    t.integer "institucionai_id", default: 20
  end

  create_table "equipes_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "equipe_id", null: false
    t.string "locale", limit: 10
    t.string "cargo", limit: 45
    t.text "texto"
  end

  create_table "estados", id: :integer, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", null: false
    t.string "sigla", limit: 2, null: false
    t.string "capital", limit: 150, null: false
  end

  create_table "events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", limit: 200, default: "", null: false
    t.integer "number_participants"
    t.date "start_date"
    t.date "end_date"
    t.string "banner_img", limit: 200
    t.string "link", limit: 200, default: "", null: false
  end

  create_table "events_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "event_id"
    t.string "locale", limit: 10
    t.string "name", limit: 200
    t.string "description", limit: 250
    t.index ["description"], name: "index_events_locales_on_description"
    t.index ["event_id"], name: "index_events_locales_on_event_id"
    t.index ["locale"], name: "index_events_locales_on_locale"
    t.index ["name"], name: "index_events_locales_on_name"
  end

  create_table "facilities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
    t.string "icon_name", limit: 100
  end

  create_table "facilities_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "facilitie_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
    t.index ["facilitie_id"], name: "index_facilities_locales_on_facilitie_id"
    t.index ["locale"], name: "index_facilities_locales_on_locale"
  end

  create_table "friendly_id_slugs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "hoteis", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.string "id_voucher", limit: 30
    t.string "id_btms", limit: 30
  end

  create_table "incluis", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
    t.string "icon_name", limit: 100
  end

  create_table "institucionais", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "tag", limit: 40, null: false
    t.string "titulo", null: false
    t.string "titulo_menu", limit: 40
    t.text "texto"
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.boolean "exibir_menu", default: false
  end

  create_table "institucionais_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "titulo", null: false
    t.string "titulo_menu", limit: 40
    t.text "texto", null: false
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.integer "institucionai_id"
    t.string "locale", limit: 10
  end

  create_table "log_integracoes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "adm_usuario_id", null: false
    t.datetime "data_hora", null: false
    t.text "info", null: false
  end

  create_table "loja_fisica_pedido_hospedagens", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "loja_fisica_pedido_id", null: false
    t.integer "produtos_hospedagem_fornecedore_id", null: false
    t.integer "quantidade", null: false
    t.float "preco_unidade", null: false
    t.float "total", null: false
    t.integer "produtos_hospedagem_configuracao_id", null: false
    t.string "categoria", limit: 50
    t.date "check_in", null: false
    t.date "check_out", null: false
    t.string "pacote_especial", limit: 50
    t.string "reserva", limit: 50
    t.integer "excluido"
    t.string "regime", limit: 100
    t.time "check_in_hora"
    t.time "check_out_hora"
    t.string "pax_description"
  end

  create_table "loja_fisica_pedido_lancamentos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "loja_fisica_pedido_id", null: false
    t.integer "adm_usuario_id", null: false
    t.string "forma_de_pagamento", limit: 100, null: false
    t.float "valor", null: false
    t.date "data", null: false
    t.string "obs", limit: 250
  end

  create_table "loja_fisica_pedido_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "adm_usuario_id", null: false
    t.integer "loja_fisica_pedido_id", null: false
    t.text "descricao", null: false
    t.string "acao", limit: 100, null: false
    t.datetime "created", null: false
  end

  create_table "loja_fisica_pedido_passageiros", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "loja_fisica_pedido_id", null: false
    t.string "nome", limit: 100, null: false
    t.integer "idade", null: false
    t.string "doc", limit: 100
    t.boolean "excluido"
    t.index ["excluido"], name: "index_loja_fisica_pedido_passageiros_on_excluido"
    t.index ["loja_fisica_pedido_id"], name: "index_loja_fisica_pedido_passageiros_on_loja_fisica_pedido_id"
  end

  create_table "loja_fisica_pedido_passeio_secundarios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "loja_fisica_pedido_passeio_id", null: false
    t.integer "produtos_passeiosecundarios_id", null: false
    t.integer "tarifa_tipo_id", null: false
    t.integer "qtde_unidade"
    t.integer "qtde_pessoa"
    t.float "preco_total"
    t.integer "estoque_id"
  end

  create_table "loja_fisica_pedido_passeios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "loja_fisica_pedido_id", null: false
    t.integer "produto_id", null: false
    t.date "passeio_data", null: false
    t.time "passeio_hora", null: false
    t.string "reserva", limit: 50
    t.integer "produto_subvariacao_id"
    t.float "total", null: false
    t.integer "excluido"
    t.integer "qtde_adt"
    t.integer "qtde_chd"
    t.integer "qtde_free"
    t.integer "qtde_adt_almoco"
    t.integer "qtde_chd_almoco"
    t.integer "qtde_free_almoco"
    t.integer "voucher_numero"
    t.integer "voucher_tabela"
    t.integer "btms_tabela"
    t.time "passeio_hora_saida"
  end

  create_table "loja_fisica_pedidos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "adm_usuario_id", null: false
    t.integer "usuario_id", null: false
    t.string "status", limit: 100
    t.string "origem"
    t.string "origem_descrita"
    t.string "categoria", limit: 100, default: ""
    t.string "hotel", limit: 100
    t.string "forma_de_pagamento", limit: 100
    t.string "numero_da_venda", limit: 150, default: "111"
    t.date "inicio_da_viagem"
    t.date "fim_da_viagem"
    t.float "subtotal"
    t.float "desconto"
    t.float "total"
    t.float "comissao"
    t.date "prazo"
    t.boolean "prazo_aviso"
    t.datetime "data", null: false
    t.text "obs"
    t.float "exclusivo"
    t.float "total_lancamentos"
    t.integer "canal_id"
    t.integer "indicador_id"
    t.integer "cs_etapa_id"
    t.string "motivo", limit: 100
    t.text "bilhete"
    t.string "canal_preferencial", limit: 100
    t.integer "funil_venda_id"
    t.integer "oportunidade_id"
    t.boolean "excluido_kanban"
    t.date "processado_em"
    t.integer "carrinho_id"
    t.integer "status_kit_id"
    t.integer "installments"
    t.float "min_installment"
    t.index ["adm_usuario_id"], name: "index_loja_fisica_pedidos_on_adm_usuario_id"
    t.index ["usuario_id"], name: "index_loja_fisica_pedidos_on_usuario_id"
  end

  create_table "my_very_own_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "authoring_class"
    t.string "authoring_method"
    t.string "authoring_user_email"
    t.text "info"
  end

  create_table "persona_day_by_days", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "persona_id", null: false
    t.integer "day_order", null: false
    t.integer "produto_id", null: false
    t.integer "block_id", null: false
  end

  create_table "personas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
    t.string "icon_name", limit: 100
    t.string "link", limit: 200, default: "", null: false
  end

  create_table "personas_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "persona_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
  end

  create_table "produto_brings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "bring_id", null: false
    t.index ["produto_id"], name: "index_produto_brings_on_produto_id"
  end

  create_table "produto_categorias", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "categoria_id", null: false
  end

  create_table "produto_facilities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "facilitie_id", null: false
    t.index ["produto_id"], name: "index_produto_facilities_on_produto_id"
  end

  create_table "produto_preferencias", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
  end

  create_table "produto_subvariacoes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "adm_usuario_id"
    t.integer "produto_variacao_id", null: false
    t.string "subvariacao", limit: 100
    t.string "tipo_de_quarto", limit: 200
    t.integer "capacidade"
    t.string "config", limit: 100
    t.float "peso"
    t.integer "estoque", default: 0, null: false
    t.float "preco_adulto"
    t.float "preco_crianca"
    t.string "numero_de_reserva", limit: 100
    t.float "preco_crianca2"
    t.string "status", limit: 12
    t.index ["adm_usuario_id"], name: "adm_usuario_id"
    t.index ["produto_variacao_id"], name: "produto_variacao_id"
  end

  create_table "produto_variacoes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "adm_usuario_id"
    t.integer "produto_id"
    t.string "variacao", limit: 100
    t.string "link"
    t.float "preco_antigo"
    t.float "preco"
    t.integer "idade_crianca"
    t.integer "idade_crianca2"
    t.string "duracao", limit: 100
    t.boolean "destaque_na_capa"
    t.string "status", limit: 12, null: false
    t.string "tag", limit: 100
    t.index ["adm_usuario_id"], name: "adm_usuario_id"
    t.index ["produto_id"], name: "produto_id"
  end

  create_table "produtos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "marca_id"
    t.boolean "hospedagem"
    t.string "nome", limit: 100, null: false
    t.string "link", null: false
    t.string "imagem_1"
    t.string "imagem_2"
    t.string "imagem_3"
    t.string "imagem_4"
    t.string "video"
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.string "resumo"
    t.text "descricao"
    t.string "titulo_variacao", limit: 100
    t.string "titulo_subvariacao", limit: 100
    t.string "tag", limit: 100
    t.boolean "status"
    t.string "localidade", limit: 45
    t.boolean "exibir_site", default: false
    t.string "ta_location", limit: 45
    t.string "ta_wtype", limit: 45
    t.string "cdgbtms_atividade", limit: 20
    t.string "cdgbtms_atrativo", limit: 20
    t.text "ploomes_descricao"
    t.string "ploomes_img"
    t.integer "ordem"
    t.time "voucher_tempo"
    t.text "voucher_obs_pt"
    t.text "voucher_obs_en"
    t.integer "duration_in_min"
    t.integer "almoco_id"
    t.integer "crianca_id"
    t.integer "abilidade_id"
    t.boolean "special_date"
    t.boolean "btms_online"
    t.index ["exibir_site"], name: "index_produtos_on_exibir_site"
    t.index ["link"], name: "index_produtos_on_link"
    t.index ["link"], name: "link_UNIQUE", unique: true
    t.index ["marca_id"], name: "marca_id"
    t.index ["status"], name: "index_produtos_on_status"
  end

  create_table "produtos_hospedagem_fornecedor_categorias", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produtos_hospedagem_fornecedor_id", null: false
    t.integer "categoria_id", null: false
  end

  create_table "produtos_hospedagem_fornecedor_facilities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produtos_hospedagem_fornecedor_id", null: false
    t.integer "facilitie_id", null: false
    t.index ["produtos_hospedagem_fornecedor_id"], name: "hotel_facilities_hotel_id"
  end

  create_table "produtos_hospedagem_fornecedores", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 50, default: "", null: false
    t.string "telefone", limit: 50
    t.string "email", limit: 50
    t.string "link"
    t.string "imagem_1"
    t.string "imagem_2"
    t.string "imagem_3"
    t.string "imagem_4"
    t.string "video"
    t.string "localidade", limit: 45
    t.boolean "exibir_site", default: false
    t.string "ta_location", limit: 45
    t.string "ta_wtype", limit: 45
    t.text "ploomes_descricao"
    t.string "ploomes_img"
    t.integer "ordem"
    t.integer "regime_id"
    t.integer "distancia_do_centro"
    t.string "centro_de", limit: 200
    t.integer "numero_de_apartamentos"
    t.integer "hotels_api_code"
    t.index ["exibir_site"], name: "index_produtos_hospedagem_fornecedores_on_exibir_site"
    t.index ["link"], name: "index_produtos_hospedagem_fornecedores_on_link"
    t.index ["link"], name: "link", unique: true
  end

  create_table "produtos_hospedagem_fornecedores_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produtos_hospedagem_fornecedore_id", null: false
    t.string "locale", limit: 10, default: "", null: false
    t.string "nome", limit: 100, default: "", null: false
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.text "descricao"
    t.index ["locale"], name: "index_produtos_hospedagem_fornecedores_locales_on_locale"
    t.index ["metatag_descricao"], name: "hotel_locales_metatag_descricao", length: 200
    t.index ["metatag_titulo"], name: "index_produtos_hospedagem_fornecedores_locales_on_metatag_titulo"
    t.index ["nome"], name: "index_produtos_hospedagem_fornecedores_locales_on_nome"
    t.index ["produtos_hospedagem_fornecedore_id"], name: "hotel_locales_hotel_id"
  end

  create_table "produtos_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 100, null: false
    t.string "link"
    t.string "video"
    t.string "metatag_titulo"
    t.text "metatag_descricao"
    t.text "descricao", null: false
    t.text "levar"
    t.index ["locale"], name: "index_produtos_locales_on_locale"
    t.index ["metatag_descricao"], name: "index_produtos_locales_on_metatag_descricao", length: 200
    t.index ["metatag_titulo"], name: "index_produtos_locales_on_metatag_titulo"
    t.index ["nome"], name: "index_produtos_locales_on_nome"
    t.index ["produto_id"], name: "index_produtos_locales_on_produto_id"
    t.index ["produto_id"], name: "marca_id"
  end

  create_table "produtos_passeiosecundarios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.string "nome", limit: 45, null: false
    t.integer "produtos_passeiosecundarios_tarifas_tipo_id"
    t.string "tipo_estoque", limit: 10
    t.boolean "eh_almoco"
  end

  create_table "produtos_passeiosecundarios_estoques", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produtos_passeiosecundario_id", null: false
    t.boolean "exibir_site", default: false
    t.integer "estoque", null: false
    t.string "reserva", limit: 45
    t.string "obs", limit: 250
    t.datetime "dia", null: false
  end

  create_table "produtos_passeiosecundarios_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "locale", limit: 10
    t.integer "produtos_passeiosecundario_id", null: false
    t.string "titulo", limit: 45, null: false
    t.string "descricao", limit: 250
  end

  create_table "produtos_passeiosecundarios_tarifas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produtos_passeiosecundario_id", null: false
    t.datetime "inicio", null: false
    t.datetime "fim", null: false
    t.integer "idade_crianca"
    t.integer "idade_crianca2"
    t.float "preco_crianca"
    t.float "preco_crianca2"
    t.float "preco_adulto"
    t.float "preco_unidade"
  end

  create_table "produtos_passeiosecundarios_tarifas_tipos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 25, null: false
    t.index ["nome"], name: "nome_UNIQUE", unique: true
  end

  create_table "produtos_passeiosecundarios_tarifas_tipos_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produtos_passeiosecundarios_tarifas_tipo_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 25
  end

  create_table "produtos_passeiotarifas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "produtos_passeiotarifas_tipo_id", null: false
    t.datetime "inicio", null: false
    t.datetime "fim", null: false
    t.integer "idade_crianca"
    t.integer "idade_crianca2"
    t.float "preco_crianca"
    t.float "preco_crianca2"
    t.float "preco_adulto", null: false
    t.index ["produto_id"], name: "index_produtos_passeiotarifas_on_produto_id"
  end

  create_table "produtos_passeiotarifas_btms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.string "btms_tabela_id", limit: 30, null: false
    t.string "btms_nome", limit: 100, null: false
    t.date "inicio", null: false
    t.date "fim", null: false
    t.integer "preferencial", limit: 1
  end

  create_table "produtos_passeiotarifas_tipos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nome", limit: 25, null: false
    t.index ["nome"], name: "nome_UNIQUE", unique: true
  end

  create_table "produtos_passeiotarifas_tipos_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produtos_passeiotarifas_tipo_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 25
    t.index ["locale"], name: "index_produtos_passeiotarifas_tipos_locales_on_locale"
    t.index ["produtos_passeiotarifas_tipo_id"], name: "tour_price_type_locales_type_id"
  end

  create_table "produtos_passeiotarifas_voucher", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.string "voucher_tabela_id", limit: 30, null: false
    t.string "voucher_nome", limit: 100, null: false
    t.date "inicio", null: false
    t.date "fim", null: false
    t.integer "preferencial", limit: 1
    t.integer "produtos_passeiotarifas_tipo_id"
  end

  create_table "produtos_relacionados", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "produtos_variacao_id", null: false
  end

  create_table "regimes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.integer "ordem"
  end

  create_table "regimes_locales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "regime_id"
    t.string "locale", limit: 10
    t.string "nome", limit: 200
  end

  create_table "search_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "searched_term"
    t.integer "number_of_results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale"
    t.integer "number_of_times"
  end

  create_table "session_cart_counts", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.date "date_recorded"
    t.integer "date_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "special_deal_brings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "special_deal_id", null: false
    t.integer "bring_id", null: false
    t.index ["special_deal_id"], name: "index_special_deal_brings_on_special_deal_id"
  end

  create_table "special_deal_incluis", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "special_deal_id", null: false
    t.integer "inclul_id", null: false
  end

  create_table "special_deal_personas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "persona_id", null: false
    t.integer "special_deal_id", null: false
  end

  create_table "special_deal_produtos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "produto_id", null: false
    t.integer "special_deal_id", null: false
    t.index ["special_deal_id"], name: "index_special_deal_produtos_on_special_deal_id"
  end

  create_table "special_deals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", limit: 200, default: "", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "photo_home", limit: 200
    t.string "photo_page", limit: 200
    t.float "true_price"
    t.float "discounted_price"
    t.integer "produtos_hospedagem_fornecedor_id"
    t.string "link", limit: 200
    t.string "tag_line", limit: 200
    t.text "descricao"
    t.date "display_start_date"
    t.date "display_end_date"
    t.index ["link"], name: "index_special_deals_on_link"
    t.index ["name"], name: "index_special_deals_on_name"
    t.index ["tag_line"], name: "index_special_deals_on_tag_line"
  end

  create_table "usuarios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "nome", limit: 100, null: false
    t.string "email", null: false
    t.string "telefone", limit: 20
    t.string "razao_social"
    t.string "doc", limit: 50
    t.string "banco", limit: 30
    t.string "agencia", limit: 30
    t.string "conta", limit: 30
    t.text "obs"
    t.string "old_hash"
    t.string "complemento", limit: 50, comment: "Usado para Cartão VIP H2O - Vivi (May.2016)"
    t.string "endereco", limit: 250
    t.string "numero", limit: 10
    t.string "bairro", limit: 40
    t.string "cidade", limit: 100
    t.string "estado", limit: 100
    t.string "cep", limit: 15
    t.string "celular", limit: 20
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_usuarios_on_confirmation_token", unique: true
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["nome"], name: "index_usuarios_on_nome"
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.text "object_changes", limit: 4294967295
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "produtos_locales", "produtos", name: "produto_id", on_update: :cascade
end
