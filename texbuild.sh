# ファイルパスの処理
filepath=$(readlink -m $1)
dir="$(dirname "$filepath")"
file="$(basename "$filepath")"
file="${file%.*}"
echo "[${dir}] [${file}]"

# ファイル名の生成
texname=$file".tex"
pdfname=$file".pdf"
pdf_tmp=$file"_tmp"
pdf_sep=$file"_%02d.pdf"

# カレントディレクトリの移動
OLDPWD=$PWD; cd $dir
echo $PWD

# すでにあるpdfとpngを削除
find -regex ".*png"
rm *pdf *png

# メインの処理（lualatex使用バージョン）
lualatex -interaction=nonstopmode --jobname=$pdf_tmp $texname
pdfcrop $pdf_tmp".pdf" $pdf_tmp".pdf"
rungs -o $pdfname -dNoOutputFonts -sDEVICE=pdfwrite $pdf_tmp".pdf"
pdfseparate $pdfname $pdf_sep
rm $pdf_tmp*
eqs=$(find -regex ".*[1-9]\.pdf" -type f )
for eq in $eqs; do
  echo $eq
  inkscape --pages=1 $eq --export-dpi=600 --export-type="png"
done

# 作業前のディレクトリに戻る
cd $OLDPWD
