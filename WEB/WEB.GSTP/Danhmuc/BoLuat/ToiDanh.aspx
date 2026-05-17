<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="ToiDanh.aspx.cs" Inherits="WEB.GSTP.Danhmuc.BoLuat.ToiDanh" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .tdWidthTblToaAn {
            width: 120px;
        }

        .check_list_vertical table td {
            padding-right: 15px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boder" style="float: left; width: 98%; margin-bottom: 10px;">
                <table class="table1">
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Bộ luật</b></td>
                        <td colspan="5">
                            <asp:Literal ID="lttTenBoLuat" runat="server"></asp:Literal>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Chương</b></td>
                        <td colspan="5">
                            <div style="float:left;"><asp:TextBox ID="txtChuong" runat="server" CssClass="user" Width="60px"></asp:TextBox></div>
                            <div style="float:left;margin-left:10px;">
                                <div style="float: left; font-weight:bold; margin-right:5px; line-height: 20px">Điều</div>
                                  <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                            </div>
                             <div style="float:left;margin-left:10px;">
                                  <div style="float: left; font-weight:bold; margin-right:5px; line-height: 20px">Khoản</div>
                                <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                            </div>
                             <div style="float:left;margin-left:10px;">
                                  <div style="float: left; font-weight:bold; margin-right:5px; line-height: 20px">Điểm</div>
                                <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                            </div>
                        </td>
                    </tr>

                   
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Tên tội danh</b><asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td colspan="5">
                            <asp:TextBox ID="txtTenToiDanh" runat="server" CssClass="user" Width="81%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Chi tiết</b></td>
                        <td colspan="5">
                            <asp:TextBox ID="txtChiTietToiDanh" runat="server" CssClass="user" TextMode="MultiLine" Rows="5" Width="82%"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdWidthTblToaAn"><b>Có khung hình phạt</b></td>
                        <td colspan="5">
                            <asp:CheckBox ID="chkIsHinhPhat" runat="server" AutoPostBack="true" OnCheckedChanged="chkIsHinhPhat_CheckedChanged" />

                        </td>
                    </tr>
                    <asp:Panel ID="pnHinhPhat" runat="server">
                        <tr>
                            <td colspan="6">
                                <div style="float: left; width: 100%;" id="zoneHinhPhat">
                                    <table style="width: 100%; float: left;">
                                        <%--<tr>
                                            <td style="width: 120px; font-weight: bold; padding: 2px 0px;">Nhóm hình phạt</td>
                                            <td>
                                                <asp:DropDownList ID="dropNhomHinhPhat" runat="server" CssClass="user"
                                                    AutoPostBack="true" OnSelectedIndexChanged="dropNhomHinhPhat_SelectedIndexChanged">
                                                </asp:DropDownList></td>
                                        </tr>--%>
                                        <tr>
                                            <td style="width: 120px; font-weight: bold; padding: 2px 0px;">Hình phạt</td>
                                            <td>
                                                <div class="check_list_vertical">
                                                    <asp:TreeView ID="treeHinhPhat" runat="server" ShowCheckBoxes="Leaf" ShowLines="true" ForeColor="#333">
                                                    </asp:TreeView>
                                                    <asp:CheckBoxList ID="chkHinhPhat" runat="server" RepeatColumns="3"></asp:CheckBoxList>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>

                    <tr>
                        <td class="tdWidthTblToaAn"><b>Hiệu lực</b></td>
                        <td colspan="5">
                            <asp:CheckBox ID="chkActive" class="check" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="5">
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu"
                                OnClick="btnUpdate_Click" OnClientClick="return Validate()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                            <asp:Button ID="cmdQuayLai" runat="server" CssClass="buttoninput" Text="Quay lại"
                                OnClick="cmdQuayLai_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="float:left;width:100%;">
                <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
            </div>
            <table style="width: 100%; margin-top: 25px;">
                <tr>
                    <td colspan="2">
                        <asp:TextBox runat="server" ID="txttimkiem" Width="30%" CssClass="user"></asp:TextBox>
                        <asp:DropDownList ID="dropHieuLuc" runat="server" CssClass="user"></asp:DropDownList>

                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                    </td>
                </tr>
            </table>
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
                                <td>
                                    <div align="center"><strong>Tội danh</strong></div>
                                </td>
                                <td width="150">
                                    <div align="center"><strong>Người tạo</strong></div>
                                </td>
                                <td width="100">
                                    <div align="center"><strong>Ngày tạo</strong></div>
                                </td>
                                <td width="70">
                                    <div align="center"><strong>Thao tác</strong></div>
                                </td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("STT") %></td>
                            <td><%#Eval("TenToiDanh") %></td>

                            <td><%# Eval("NguoiTao") %></td>
                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayTao")) %></td>
                            <td>
                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>

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
    <script>
        function Validate() {
           <%-- var txtDieu = document.getElementById('<%= txtDieu.ClientID%>');
            var txtDieu = document.getElementById('<%=txtDieu.ClientID%>');
            if (!Common_CheckEmpty(txtDieu.value)) {
                alert('Bạn chưa nhập mục "Điều". Hãy kiểm tra lại!');
                txtDieu.focus();
                return false;
            }--%>
            var txtTen = document.getElementById('<%=txtTenToiDanh.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập "Tên tội danh". Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            return true;
        }

    </script>
</asp:Content>
