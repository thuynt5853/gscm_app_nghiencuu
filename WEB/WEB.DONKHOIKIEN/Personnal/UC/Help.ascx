<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Help.ascx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.UC.Help" %>


<div class="tooltip">
    <a href="javascript:;" onclick="Open_Help('<%=CodePage %>');">
        <img src="../../UI/img/support.png" alt="Hướng dẫn" style="border: none;" />
    </a><span class="tooltiptext  tooltip-bottom">Hướng dẫn</span>
</div>

<script>
    function Open_Help(ma_trang) {
        var link = "/Personnal/UC/ShowHelp.aspx?ma=" + ma_trang;
        var width = 900;
        var height = 650;
        PopupCenter(link, "Hướng dẫn", width, height);
    }
    function PopupCenter(pageURL, title, w, h) {
        var left = (screen.width / 2) - (w / 2);
        var top = (screen.height / 2) - (h / 2);
        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
        return targetWin;
    }
</script>
