var $llama : cs:C1710.llama.llama

var $homeFolder : 4D:C1709.Folder
$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".GGUF")
var $file : 4D:C1709.File
var $URL : Text
var $port : Integer
var $huggingface : cs:C1710.event.huggingface

var $event : cs:C1710.event.event
$event:=cs:C1710.event.event.new()

$event.onError:=Formula:C1597(OnModelDownloaded)
$event.onSuccess:=Formula:C1597(OnModelDownloaded)
$event.onData:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":"+String:C10((This:C1470.range.end/This:C1470.range.length)*100; "###.00%")))
$event.onResponse:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; This:C1470.file.fullName+":download complete"))
$event.onTerminate:=Formula:C1597(LOG EVENT:C667(Into 4D debug message:K38:5; (["process"; $1.pid; "terminated!"].join(" "))))

$port:=8080

var $folder : 4D:C1709.Folder
var $logFile : 4D:C1709.File
var $path; $cache_type_k; $cache_type_v : Text
var $threads; $batches; $ubatch_size; $batch_size; $ctx_size : Integer
var $n_gpu_layers : Integer
$folder:=$homeFolder.folder("AI21-Jamba2-3B")
$path:="AI21-Jamba2-3B-Q8_0.gguf"
$URL:="keisuke-miyako/AI21-Jamba2-3B-gguf-q8_0"
$threads:=6
$batches:=1
$ubatch_size:=512
$batch_size:=2048

$ctx_size:=262144
$cache_type_k:="f16"
$cache_type_v:="f16"
$n_gpu_layers:=99

$logFile:=$folder.file("llama.log")
$folder.create()
If (Not:C34($logFile.exists))
	$logFile.setContent(4D:C1709.Blob.new())
End if 

var $options : Object
$options:={\
ctx_size: $ctx_size; \
batch_size: $batch_size; \
ubatch_size: $ubatch_size; \
parallel: $batches; \
threads: $threads; \
threads_batch: $threads; \
threads_http: 2; \
n_gpu_layers: $n_gpu_layers; \
cache_type_k: $cache_type_k; \
cache_type_v: $cache_type_v; \
flash_attn: "on"; \
n_predict: -1; \
temp: 0.7; \
top_k: 40; \
top_p: 0.9; \
repeat_penalty: 1; \
log_disable: False:C215; \
log_file: $logFile; \
jinja: True:C214}

var $huggingfaces : cs:C1710.event.huggingfaces

$huggingface:=cs:C1710.event.huggingface.new($folder; $URL; $path)
$huggingfaces:=cs:C1710.event.huggingfaces.new([$huggingface])

$llama:=cs:C1710.llama.llama.new($port; $huggingfaces; $homeFolder; $options; $event)