<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Home_TraCuuHS.ascx.cs" Inherits="WEB.DONKHOIKIEN.UserControl.Home_TraCuuHS" %>
<div class="tracuu">
    <div class="tracuu_header">Tra cứu hồ sơ</div>
    <div style="float: left;">
        <asp:TextBox ID="txtMaVuViec" runat="server" placeholder="Mã hồ sơ" CssClass="textbox" />
        <asp:TextBox ID="txtTuKhoa" runat="server" placeholder="Mã bảo mật" CssClass="textbox" />

        <asp:TextBox ID="txtMaCapCha" runat="server" placeholder="Mã kiểm tra" CssClass="textbox" />
        
        <span class="capcha_code"><asp:Literal ID ="lttRandom" runat="server"></asp:Literal>
            <asp:HiddenField ID="hddTempCode" runat="server" /></span>
        <input type="button" value="Tra cứu" class="button" onclick="TraCuu();" />
    </div>
</div>
<script>
    function TraCuu() {
       
        var txtMaVuViec = document.getElementById('<%=txtMaVuViec.ClientID%>');
        var txtTuKhoa = document.getElementById('<%=txtTuKhoa.ClientID%>');
        var link = "";
        if (Common_CheckEmpty(txtMaVuViec.value)) {
            if (link.length > 0)
                link += "&"
            else link += "?";
            link += "ma=" + txtMaVuViec.value;
        }
        
        //--------------------------
        if (Common_CheckEmpty(txtTuKhoa.value)) {
            if (link.length > 0)
                link += "&"
            else link += "?";
            link += "text=" + txtTuKhoa.value;
        }
        
        var txtMaCapCha = document.getElementById('<%=txtMaCapCha.ClientID%>');
        var hddTempCode = document.getElementById('<%=hddTempCode.ClientID%>');
       
        if (txtMaCapCha.value == hddTempCode.value)
            window.location.href = "TraCuu.aspx" + link;
        else {
            alert('Mã kiểm tra chưa nhập đúng. Hãy kiểm tra lại!');
            txtMaCapCha.focus();
            return false;
        }
    }
</script>

