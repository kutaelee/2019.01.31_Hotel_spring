<%@page contentType="text/html; charset=utf-8" %>
<div class="file_list"></div>
<button class="back_btn" onclick=pageload(curpagenum)>돌아가기</button>
<div class="board_write_div">
<form class="board_insert_form" id="board_insert_form" enctype="multipart/form-data" accept-charset = "utf-8">
<input type="checkbox" class="input_lock"><label for="lock">비밀글</label>
<input type="hidden" class="input_writer" name="writer" >
<input type="text" name="title" class="input_title" placeholder=" 제목 최대 30자" maxlength="30">
<textarea name="content" class="input_content"  placeholder="문의하실 내용 최대 1000자" rows="50" cols="20" wrap="hard" ></textarea>
<input type="text" name="lock" class="input_hidden" style="display: none;" />
<input multiple="multiple" id="img_file"type="file" name="file[]" accept="image/*">
</form>

<button class="board_insert_btn">등록</button>
</div>