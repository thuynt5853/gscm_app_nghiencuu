<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="uDSBiCan.ascx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.uDSBiCan" %>

<asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
<asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

<%--<a href="javascript:;" onclick="popup_edit_bicao(0);" 
    style="float: right;" class="buttonpopup">Thêm bị can</a>--%>
<asp:HiddenField ID="hddVuAnID" Value="" runat="server" />
<asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
<asp:HiddenField ID="hddShowCommand" runat="server" Value="True" />
<span class="msg_error">
    <asp:Literal ID="LtrThongBao" runat="server"></asp:Literal></span>
<asp:Panel ID="pnPagingTop" runat="server">
    <div class="phantrang">
        <div class="sobanghi">
            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                OnClick="lbTNext_Click"></asp:LinkButton>
        </div>
    </div>
</asp:Panel>
<table class="table2" style="width: 100%" border="1">
    <tr class="header">
        <td width="42">
            <div align="center"><strong>TT</strong></div>
        </td>
        <td width="90px">
            <div align="center"><strong>Bị can đầu vụ</strong></div>
        </td>
        <td style="width: 20%">
            <div align="center"><strong>Bị can</strong></div>
        </td>
        <td width="100px">
            <div align="center"><strong>Ngày tham gia</strong></div>
        </td>
        <td>
            <div align="center"><strong>Tội danh chính</strong></div>
        </td>
        <td width="70">
            <div align="center"><strong>Thao tác</strong></div>
        </td>
    </tr>
    <asp:Repeater ID="rptBiCan" runat="server" OnItemCommand="rptBiCan_ItemCommand" OnItemDataBound="rptBiCan_ItemDataBound">
        <ItemTemplate>
            <tr>
                <td>
                    <div align="center"><%# Eval("STT") %></div>
                </td>
                <td>
                    <div align="center">
                        <asp:CheckBox ID="chk" runat="server" Enabled="false"
                            Checked='<%# (Convert.ToInt16(Eval("BICANDAUVU"))>0)? true:false %>' />
                    </div>
                </td>
                <td><%#Eval("HoTen") %></td>

                <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayThamGia")) %></td>
                <td><%# Eval("TenToiDanh") %></td>
                <td>
                    <div align="center">
                        <asp:Literal ID="lttSua" runat="server"></asp:Literal>
                        &nbsp;&nbsp;
                <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false"
                    Text="Xóa" ForeColor="#0e7eee"
                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>'
                    ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                    </div>
                </td>
            </tr>
        </ItemTemplate>
    </asp:Repeater>
</table>
<asp:Panel ID="pnPagingBottom" runat="server">
    <div class="phantrang_bottom">
        <div class="sobanghi">
            <asp:HiddenField ID="hdicha" runat="server" />
            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
        </div>
        <div class="sotrang">
            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                OnClick="lbTBack_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                OnClick="lbTNext_Click"></asp:LinkButton>
        </div>
    </div>
</asp:Panel>
<script>
    function popup_edit_bicao(BiCaoID) {
        var hddVuAnID = document.getElementById('<%=hddVuAnID.ClientID%>');
        var VuAnID = hddVuAnID.value;
        //  alert(VuAnID);
        var link = "";
        if (BiCaoID > 0)
            link = "/QLAN/THA/Hoso/DanhsachBiCan.aspx?hsID=" + VuAnID + "&bID=" + BiCaoID;
        else
            link = "/QLAN/THA/Hoso/DanhsachBiCan.aspx?hsID=" + VuAnID;
        var width = 800;
        var height = 900;
        PopupCenter(link, "Cập nhật thông tin bị can", width, height);
    }
    function ReloadParent() {
        LoadDsBiCan();
        //window.onunload = function (e) {
        //    opener.LoadDsBiCan();
        //};
        //window.close();
    }
</script>

