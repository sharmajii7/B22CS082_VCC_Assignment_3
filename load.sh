# while true; do curl http://localhost:5000/simulate_load; echo ""; done
count=0
while true; do
  curl http://localhost:5000/simulate_load
  echo ""
  count=$((count + 1))
  if [ "$count" -eq 5 ]; then
    sudo bash assignment3.sh &
    # count=0  # Reset count if you want to repeat the process
  fi
  # echo ""
done
