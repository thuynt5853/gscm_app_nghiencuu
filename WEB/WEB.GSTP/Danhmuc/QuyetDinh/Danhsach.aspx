<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.QuyetDinh.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <asp:HiddenField ID="hddCountAllItem" Value="1" runat="server" />
    <style type="text/css">
        .btnTimKiemCss {
            margin-left: 5px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2" style="text-align: left;">
                            <asp:Button ID="btnNew" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnNew_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 122px;"><b>Mã loại quyết định</b><asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="150px" MaxLength="20"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Tên loại quyết định</b><asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="99%" MaxLength="250"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>Có thông tin đương sự?</td>
                        <td>
                            <asp:CheckBox ID="chkDuongsuYC" class="check" runat="server" Text="" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Thứ tự</b></td>
                        <td>
                            <asp:DropDownList CssClass="user" ID="DropThuTu" runat="server" Width="70px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Loại án áp dụng</b></td>
                        <td>
                            <asp:CheckBox ID="chkHinhSu" class="check" runat="server" Text="Hình sự" />
                            <asp:CheckBox ID="chkDanSu" class="check" runat="server" Text="Dân sự" />
                            <asp:CheckBox ID="chkHonNhanGD" class="check" runat="server" Text="Hôn nhân & Gia đình" />
                            <asp:CheckBox ID="chkKDTM" class="check" runat="server" Text="Kinh doanh thương mại" />
                            <br />
                            <asp:CheckBox ID="chkLaoDong" class="check" runat="server" Text="Lao động" />
                            <asp:CheckBox ID="chkHanhChinh" class="check" runat="server" Text="Hành chính" />
                              <asp:CheckBox ID="chkPhasan" class="check" runat="server"  Text="Phá sản" />
                              <asp:CheckBox ID="chkXLHC" class="check" runat="server"  Text="BP Xử lý hành chính" />
                        </td>
                    </tr>
                    <tr>
                        <td><b>Hiệu lực</b></td>
                        <td>
                            <asp:CheckBox ID="chkHieuluc" runat="server" /></td>
                    </tr>
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return KtratenDV()" />
                            <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                <asp:HiddenField ID="hddLoaiQdID" runat="server" Value="0" />
                                <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                            </div>
                            <table style="width: 300px; margin-top: 10px;">
                                <tr>
                                    <td style="width: 150px;">
                                        <asp:TextBox runat="server" ID="txttimkiem" Width="99%" CssClass="user" placeholder="Mã, tên tòa án"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput btnTimKiemCss" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel runat="server" ID="pndata">
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
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="Id" Visible="false"></asp:BoundColumn>
                                 <%--       <asp:TemplateColumn HeaderStyle-Width="50px" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thứ tự
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtThuTu" runat="server" 
                                                    Text=' <%#Eval("STT")%>'
                                                    onkeypress="return isNumber(event)"></asp:TextBox>
                                               
                                            </ItemTemplate>
                                        </asp:TemplateColumn>--%>
                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="130px" ItemStyle-Width="130px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Mã quyết định
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("MA")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên quyết định
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TEN") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-Width="80px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                                &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                    CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa bản ghi này? ');"></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
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
                                <div style="float: left; margin-top: 6px;" runat="server" id="div_Order">
                                    <asp:Button ID="cmdThutu" runat="server" CssClass="buttoninput" Text="Lưu thứ tự" OnClick="cmdThutu_Click" />
                                </div>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function KtratenDV() {
            var txtMa = document.getElementById('<%=txtMa.ClientID %>');
            if (txtMa.value.trim() == "" || txtMa.value.trim() == null) {
                alert('Bạn chưa nhập mã loại quyết định!');
                txtMa.focus();
                return false;
            }
            else if (txtMa.value.trim().length > 20) {
                alert('Mã loại quyết định không được quá 20 ký tự. Hãy nhập lại!');
                txtMa.focus();
                return false;
            }
            var txtTen = document.getElementById('<%=txtTen.ClientID %>');
            if (txtTen.value.trim() == "" || txtTen.value.trim() == null) {
                alert('Bạn chưa nhập tên loại quyết định!');
                txtTen.focus();
                return false;
            }
            else if (txtTen.value.trim().length > 250) {
                alert('Tên loại quyết định không được quá 250 ký tự. Hãy nhập lại!');
                txtTen.focus();
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
