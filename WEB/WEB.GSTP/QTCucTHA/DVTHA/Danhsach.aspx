<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="Danhsach.aspx.cs" Inherits="WEB.GSTP.QTCucTHA.DVTHA.Danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="80" runat="server" />
    <style type="text/css">
        .btnTimKiemCss {
            margin-left: 5px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <%--DL lay tu bang : DM_DonViThiHanhAn, Bo sung thêm côt ArrToaAnID (varchar)  --> luu ds cac toaanid mà đơn vị này được phép thu hộ án phí (cột này lưu dv1|dv2|dv3)--%>
                <table class="table1">
                    <tr>
                        <td style="width: 30%; vertical-align: top; border-right: 1px solid #ccc;">
                            <div style="margin: -10px;">
                                <asp:TreeView ID="treemenu" runat="server" NodeWrap="True" ShowLines="True" OnSelectedNodeChanged="treemenu_SelectedNodeChanged">
                                    <NodeStyle ImageUrl="../../UI/img/folder.gif" HorizontalPadding="3" Width="100%" CssClass="tree_menu"
                                        VerticalPadding="3px" />
                                    <ParentNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <RootNodeStyle ImageUrl="../../UI/img/root.gif" />
                                    <SelectedNodeStyle Font-Bold="True" />
                                </asp:TreeView>
                            </div>
                        </td>
                        <td style="width: 70%; vertical-align: top; text-align: left">
                            <table style="width: 100%; padding: 3px; border-spacing: 3px;">
                                <tr>
                                    <td colspan="2" style="text-align: left;">
                                        <asp:Button ID="btnNew" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnNew_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 120px;"><b>Mã ĐV THADS</b><asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtMa" CssClass="user" runat="server" Width="200px" MaxLength="50"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td><b>Tên ĐV THADS</b><asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td><b>Đơn vị THADS cấp trên</b></td>
                                    <td>
                                        <asp:DropDownList CssClass="chosen-select" ID="dropParent" runat="server" Width="300px" OnSelectedIndexChanged="dropParent_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td><b>Loại đơn vị THADS</b></td>
                                    <td>
                                        <asp:DropDownList CssClass="chosen-select" ID="dropLoaiToaAn" runat="server" Width="300px"></asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td><b>Đơn vị hành chính</b></td>
                                    <td>
                                        <asp:HiddenField ID="hddDonViHanhChinh" runat="server" />
                                        <asp:TextBox ID="txtDonViHanhChinh" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td><b>Địa chỉ</b></td>
                                    <td>
                                        <asp:TextBox ID="txtDiaChi" CssClass="user" runat="server" Width="100%"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td><b>Điện thoại</b></td>
                                    <td>
                                        <asp:TextBox ID="txtDienThoai" CssClass="user" runat="server" Width="120px"></asp:TextBox>
                                        <span style="font-weight: bold; margin: 0px 5px 0px 10px;">Fax</span>
                                        <asp:TextBox ID="txtFax" CssClass="user" runat="server" Width="120px"></asp:TextBox>
                                        <span style="font-weight: bold; margin: 0px 5px 0px 10px;">Email</span>
                                        <asp:TextBox ID="txtEmail" CssClass="user" runat="server" Width="180px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Thứ tự</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList CssClass="user" ID="dropThuTu" runat="server" Width="71px"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Hiệu lực</b>
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tên cơ quan thi hành án tương ứng</td>
                                    <td>
                                        <asp:TextBox ID="txtTenCQTHA" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Địa chỉ</td>
                                    <td>
                                        <asp:TextBox ID="txtDiachiCQTHA" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <td>Nhận đơn khởi kiện trực tuyến</td>
                                    <td>
                                        <asp:RadioButtonList ID="rdNhanDKKOnline" runat="server"
                                            RepeatDirection="Horizontal">
                                            <asp:ListItem Value="0" Selected="True">Không</asp:ListItem>
                                            <asp:ListItem Value="1">Có</asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnUpdate_Click" OnClientClick="return ValidateDataInput();" />
                                        <asp:Button ID="cmdDel" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnDel_Click" OnClientClick="return confirm('Bạn chắc chắn muốn xóa ?');" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLammoi_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div>
                                            <asp:HiddenField ID="hddToaAnID" runat="server" Value="0" />
                                            <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        </div>
                                        <table style="width: 300px; margin-top: 10px; border-spacing: 5px;">
                                            <tr>
                                                <td style="width: 150px;">
                                                    <asp:TextBox runat="server" ID="txttimkiem" Width="100%" CssClass="user" placeholder="Mã, tên tòa án"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Button ID="Btntimkiem" runat="server" CssClass="buttoninput btnTimKiemCss" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />
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
                                                    <asp:TemplateColumn HeaderStyle-Width="40px" ItemStyle-Width="40px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Thứ tự
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <asp:DropDownList CssClass="user" ID="DropThuTuChildren" runat="server" Width="98%"></asp:DropDownList>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-Width="150px" HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Mã
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <%#Eval("MA")%>
                                                        </ItemTemplate>
                                                    </asp:TemplateColumn>
                                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                                        <HeaderTemplate>
                                                            Tên tòa án
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
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">

        function ValidateDataInput() {
            var txtMaControl = document.getElementById('<%=txtMa.ClientID %>');
            if (txtMaControl.value.trim() == "" || txtMaControl.value.trim() == null) {
                alert('Bạn hãy nhập mã tòa án!');
                txtMaControl.focus();
                return false;
            } else if (txtMaControl.value.trim().length > 50) {
                alert('Mã tòa án không được quá 50 ký tự. Hãy nhập lại!');
                txtMaControl.focus();
                return false;
            }

            var txtTenControl = document.getElementById('<%=txtTen.ClientID %>');
            if (txtTenControl.value.trim() == "" || txtTenControl.value.trim() == null) {
                alert('Bạn hãy nhập tên tòa án!');
                txtTenControl.focus();
                return false;
            } else if (txtTenControl.value.trim().length > 250) {
                alert('Tên tòa án không được quá 250 ký tự. Hãy nhập lại!');
                txtTenControl.focus();
                return false;
            }
            var txtDiaChi = document.getElementById('<%=txtDiaChi.ClientID %>');
            if (txtDiaChi.value.trim().length > 250) {
                alert('Địa chỉ không được quá 250 ký tự. Hãy nhập lại!');
                txtDiaChi.focus();
                return false;
            }
            var txtDienThoai = document.getElementById('<%=txtDienThoai.ClientID %>');
            if (txtDienThoai.value.trim().length > 250) {
                alert('Điện thoại không được quá 250 ký tự. Hãy nhập lại!');
                txtDienThoai.focus();
                return false;
            }
            var txtFax = document.getElementById('<%=txtFax.ClientID %>');
            if (txtFax.value.trim().length > 150) {
                alert('Fax không được quá 150 ký tự. Hãy nhập lại!');
                txtFax.focus();
                return false;
            }
            var txtEmail = document.getElementById('<%=txtEmail.ClientID %>');
            if (txtEmail.value.trim().length > 150) {
                alert('Email không được quá 150 ký tự. Hãy nhập lại!');
                txtEmail.focus();
                return false;
            }
            return true;
        }
        function pageLoad(sender, args) {
            $(function () {
                var urldmHanhchinh = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/GetDMHanhchinh") %>';
                $("[id$=txtDonViHanhChinh]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldmHanhchinh, data: "{ 'q': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) { $("[id$=hddDonViHanhChinh]").val(i.item.val); }, minLength: 1
                });
            });

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
