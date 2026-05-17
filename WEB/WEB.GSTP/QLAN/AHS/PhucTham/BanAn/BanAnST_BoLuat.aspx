<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="BanAnST_BoLuat.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.BanAn.BanAnST_BoLuat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddID" runat="server" Value="0" />
    <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style>
        .align_right {
            text-align: right;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">

                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                    <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                </div>
                <div class="boxchung">
                    <h4 class="tleboxchung">Điều luật áp dụng cho bị can trong bản án phúc thẩm</h4>
                    <div class="boder" style="padding: 10px;">
                        <table class="table1">
                            <tr>
                                <td style="width: 115px;"><b>Tên bị can</b></td>
                                <td style="width: 230px;">
                                    <asp:DropDownList ID="dropBiCao" CssClass="chosen-select" runat="server" Width="215px" AutoPostBack="true" OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                                <td style="width: 105px;"></td>
                                <td></td>

                            </tr>
                            <tr>
                                <td><b>Bộ luật</b><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropBoLuat" runat="server"
                                        CssClass="chosen-select" Width="80%" Height="31px"
                                        AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                                    </asp:DropDownList></td>
                                <td><b>Ngày ban hành</b><span class="batbuoc">(*)</span></td>
                                <td>
                                    <asp:DropDownList ID="dropNgayBH" runat="server" CssClass="chosen-select" Width="150px" Height="31px">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Điểm</b></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                    <b style="width: 50px;">Khoản</b><span class="batbuoc">(*)</span>
                                    <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                    <b style="width: 50px;">Điều<span class="batbuoc">(*)</span></b>
                                    <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="3">
                                    <div style="margin: 5px; text-align: center; width: 95%">
                                        <%--<asp:Button ID="cmdSearch" runat="server" CssClass="buttoninput"
                                            Text="Tìm kiếm" OnClick="cmdSearch_Click" />--%>
                                        <asp:Button ID="cmdThemDieuLuat" runat="server" CssClass="buttoninput"
                                            Text="Thêm" OnClick="cmdThemDieuLuat_Click"
                                            OnClientClick="return ValidateThemDL();" />
                                        <input type="button" id="cmdTongHopHinhPhat" onclick="popupTongHopHinhPhat();" value="Tổng hợp hình phạt" class="buttoninput" />
                                        <input type="button" id="cmdChonTD" onclick="popupChonToiDanh();" value="Chọn điều luật" class="buttoninput" />
                                        <input type="button" class="buttoninput" onclick="window.location.href = 'Dsbicao.aspx';" value="Quay lại" />
                                    </div>
                                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                        <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                      
                    </div>

                    <asp:Panel runat="server" ID="pndata" Visible="false">
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
                        <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                            <HeaderTemplate>
                                <table class="table2" width="100%" border="1">
                                    <tr class="header">
                                        <td width="42">
                                            <div align="center"><strong>TT</strong></div>
                                        </td>
                                        <td width="10%">
                                            <div align="center"><strong>Tên bộ luật</strong></div>
                                        </td>

                                        <td width="50px">
                                            <div align="center"><strong>Điểm</strong></div>
                                        </td>
                                        <td width="50px">
                                            <div align="center"><strong>Khoản</strong></div>
                                        </td>
                                        <td width="50px">
                                            <div align="center"><strong>Điều</strong></div>
                                        </td>
                                        <td>
                                            <div align="center"><strong>Tội danh</strong></div>
                                        </td>
                                        <td width="20%">
                                            <div align="center"><strong>Hình phạt</strong></div>
                                        </td>
                                        <td width="100">
                                            <div align="center"><strong>Thao tác</strong></div>
                                        </td>
                                    </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("STT") %></td>
                                    <td><%#Eval("TenBoLuat") %></td>
                                    <td><%# Eval("Diem") %></td>
                                    <td><%# Eval("Khoan") %></td>
                                    <td><%# Eval("Dieu") %></td>
                                    <td><%# Eval("TenToiDanh") %></td>
                                    <td>
                                        <asp:HiddenField ID="hddToiDanh" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                        <asp:HiddenField ID="hddBoLuat" runat="server" Value='<%#Eval("DieuLuatID") %>' />
                                        <asp:Literal ID="lttHinhPhat" runat="server"></asp:Literal></td>
                                    <td>
                                        <div align="center">
                                            <asp:Panel ID="lkHinhPhat" runat="server">
                                                <a href="javascript:;" onclick="popupChonHinhPhat(<%#Eval("ToiDanhID") %>)">Hình phạt</a>
                                            </asp:Panel>
                                            <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                CommandName="Xoa" CommandArgument='<%#Eval("ToiDanhID") %>' ToolTip="Xóa"
                                                OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate></table></FooterTemplate>
                        </asp:Repeater>

                        <div class="phantrang">
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

                </div>

            </div>
        </div>
    </div>
    <script>
                            function pageLoad(sender, args) {
                                $(function () {
                                    var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                                    for (var selector in config) { $(selector).chosen(config[selector]); }
                                });
                            }
                            function ValidateThemDL() {
                                var dropBoLuat = document.getElementById('<%=dropBoLuat.ClientID%>');
             value_change = dropBoLuat.options[dropBoLuat.selectedIndex].value;
             if (value_change == "0") {
                 alert('Bạn chưa chọn bộ luật. Hãy kiểm tra lại!');
                 dropBoLuat.focus();
                 return false;
             }

             var dropNgayBH = document.getElementById('<%=dropNgayBH.ClientID%>');
             value_change = dropNgayBH.options[dropNgayBH.selectedIndex].value;
             if (value_change == "") {
                 alert('Bạn chưa chọn ngày ban hành. Hãy kiểm tra lại!');
                 dropBoLuat.focus();
                 return false;
             }

             var txtKhoan = document.getElementById('<%=txtKhoan.ClientID%>');
             if (!Common_CheckEmpty(txtKhoan.value)) {
                 alert('Bạn chưa nhập mục "Khoản". Hãy kiểm tra lại!');
                 txtKhoan.focus();
                 return false;
             }

             var txtDieu = document.getElementById('<%=txtDieu.ClientID%>');
             if (!Common_CheckEmpty(txtDieu.value)) {
                 alert('Bạn chưa nhập mục "Điều". Hãy kiểm tra lại!');
                 txtDieu.focus();
                 return false;
             }
             return true;
         }

    </script>
      <script>
                            function popupChonHinhPhat(ToiDanhID) {
                                var link = "pChonHinhPhat.aspx?aID=<%=BanAnID%>&bID=<%=BiCanID%>&tID=" + ToiDanhID;
                                var width = 800;
                                var height = 550;
                                PopupCenter(link, "Cập nhật hình phạt", width, height);
                            }
                            function popupChonToiDanh() {
                                var link = "pChonToiDanh.aspx?aID=<%=BanAnID%>&bID=<%=BiCanID%>";
                                var width = 800;
                                var height = 550;
                                PopupCenter(link, "Cập nhật điều luật áp dụng cho bị can", width, height);
                            }
                            function popupTongHopHinhPhat(BanAnID, BiCanID) {
                                alert("Chua tao form tong hop hinhphat");
                                //var link = "ChonToiDanh.aspx?aID=" + BanAnID + "&bID=" + BiCanID;
                                //var width = 800;
                                //var height = 550;
                                //PopupCenter(link, "Cập nhật điều luật áp dụng cho bị can", width, height);
                            }
                            function PopupCenter(pageURL, title, w, h) {
                                var left = (screen.width / 2) - (w / 2);
                                var top = (screen.height / 2) - (h / 2);
                                var targetWin = window.open(pageURL, title, 'width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                                return targetWin;
                            }
                        </script>

</asp:Content>

