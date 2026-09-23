#!/bin/bash

MODEL="llama3.2:3b"
OUT="$HOME/experimentos.csv"

echo "execucao,configuracao,entrada,repeticao,tempo_total_s,load_s,prompt_tokens,output_tokens,tokens_s,erro" > "$OUT"

curta="Explique em poucas frases o que é um processo e qual a diferença entre processo e thread em um sistema operacional."

longa="Explique os conceitos de processo, thread, escalonamento de CPU e concorrência em sistemas operacionais. Descreva como processos e threads utilizam recursos computacionais, como CPU e memória, e explique de forma objetiva como o sistema operacional coordena a execução de múltiplas threads. Apresente também um exemplo simples de situação em que dois processos precisam compartilhar recursos."

run_one() {
    EXEC="$1"
    CONFIG="$2"
    INPUT_NAME="$3"
    REP="$4"
    CTX="$5"
    PROMPT="$6"

    START=$(date +%s.%N)

    RESPONSE=$(curl -s http://localhost:11434/api/generate \
      -H "Content-Type: application/json" \
      -d "$(python3 -c 'import json,sys; print(json.dumps({"model":"llama3.2:3b","prompt":sys.argv[1],"stream":False,"options":{"num_ctx":int(sys.argv[2]),"num_predict":64},"keep_alive":"5m"}))' "$PROMPT" "$CTX")")

    END=$(date +%s.%N)

    TOTAL=$(python3 -c "print(round($END-$START,3))")

    python3 - "$RESPONSE" "$EXEC" "$CONFIG" "$INPUT_NAME" "$REP" "$TOTAL" >> "$OUT" <<'PY'
import json, sys

try:
    data=json.loads(sys.argv[1])
    execucao=sys.argv[2]
    config=sys.argv[3]
    entrada=sys.argv[4]
    rep=sys.argv[5]
    total=sys.argv[6]

    load=data.get("load_duration",0)/1e9
    prompt_tokens=data.get("prompt_eval_count",0)
    output_tokens=data.get("eval_count",0)
    eval_duration=data.get("eval_duration",0)/1e9

    tok_s=(output_tokens/eval_duration) if eval_duration > 0 else 0

    erro=data.get("error","OK")

    print(f"{execucao},{config},{entrada},{rep},{total},{load:.3f},{prompt_tokens},{output_tokens},{tok_s:.2f},{erro}")

except Exception as e:
    print(f"{sys.argv[2]},{sys.argv[3]},{sys.argv[4]},{sys.argv[5]},{sys.argv[6]},,,,,ERRO:{e}")
PY
}

echo "=== C1 ==="
run_one 1 C1 Curta 1 4096 "$curta"
run_one 2 C1 Curta 2 4096 "$curta"
run_one 3 C1 Longa 1 4096 "$longa"
run_one 4 C1 Longa 2 4096 "$longa"

echo "=== C2 ==="

(
    run_one 5 C2 Curta 1 4096 "$curta"
) &
PID1=$!

(
    run_one 6 C2 Curta 2 4096 "$curta"
) &
PID2=$!

wait $PID1 $PID2

(
    run_one 7 C2 Longa 1 4096 "$longa"
) &
PID1=$!

(
    run_one 8 C2 Longa 2 4096 "$longa"
) &
PID2=$!

wait $PID1 $PID2

echo "=== C3 ==="
run_one 9 C3 Curta 1 2048 "$curta"
run_one 10 C3 Curta 2 2048 "$curta"
run_one 11 C3 Longa 1 2048 "$longa"
run_one 12 C3 Longa 2 2048 "$longa"

echo
echo "=== EXPERIMENTOS CONCLUÍDOS ==="
cat "$OUT"
