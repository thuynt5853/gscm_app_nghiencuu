<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP_VBD.Master" AutoEventWireup="true" CodeBehind="Capnhatkhangcaoquahan_AKT.aspx.cs" Inherits="WEB.GSTP.QLAN.KHANGCAOQUAHAN.Capnhatkhangcaoquahan_AKT" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../../../UI/css/Vanbanden.css" rel="stylesheet" />

    <style>
        .modalPopup .header {
            background-color: #a4212a;
            height: 30px;
            color: White;
            line-height: 22px;
            text-align: center;
            font-weight: bold;
        }
    </style>

    <asp:Panel ID="pnDanhsach" runat="server">
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
        <asp:HiddenField ID="hddTPCT" Value="0" runat="server" />
        <asp:HiddenField ID="hddTPTV1" Value="0" runat="server" />
        <asp:HiddenField ID="hddTPTV2" Value="0" runat="server" />

        <asp:UpdatePanel runat="server" ID="Ajax_Manager_Updata">
            <ContentTemplate>
                <div class="box">
                    <div class="box_nd">
                        <div class="truong">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div class="boxchung">
                                            <h4 class="tleboxchung">Tìm kiếm vụ việc</h4>
                                            <div class="boder" style="padding: 10px;">
                                                <table class="table1">
                                                    <tr>
                                                        <td style="width: 105px;">Mã vụ việc</td>
                                                        <td style="width: 260px;">
                                                            <asp:TextBox ID="txtMaVuViec" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></td>
                                                        <td style="width: 62px;">Tên vụ việc</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Số BA/QĐ</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_SoBAQD" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                        </td>
                                                        <td>Ngày BA/QĐ</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_NgayBAQD" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtTimkiem_NgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender10" runat="server" TargetControlID="txtTimkiem_NgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTimkiem_NgayBAQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Người kháng cáo</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_NguoiKC" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox>
                                                        </td>
                                                        <td>Ngày kháng cáo từ</td>
                                                        <td>
                                                            <div style="float: left; width: 101px; text-align: right; margin-right: 10px;">
                                                                <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                                <cc1:CalendarExtender ID="txtNgayQuyetDinh_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                            </div>
                                                        </td>
                                                        <td>Đến ngày</td>
                                                        <td>
                                                            <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Số thụ lý</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_SoTL" CssClass="user" runat="server" Width="242px" MaxLength="50"></asp:TextBox></t
                                                        </td>
                                                        <td>Thụ lý từ ngày</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_TuNgayTL" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtTimkiem_TuNgayTL" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtTimkiem_TuNgayTL" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTimkiem_TuNgayTL" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                        <td>Đến ngày</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTimkiem_DenNgayTL" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender10" runat="server" TargetControlID="txtTimkiem_DenNgayTL" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtTimkiem_DenNgayTL" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTimkiem_DenNgayTL" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>Tình trạng giải quyết</td>
                                                        <td>
                                                            <div style="width: 242px;">
                                                                <asp:DropDownList ID="ddlTimkiem_Trangthai" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="242px" OnSelectedIndexChanged="ddlTimkiem_Trangthai_SelectedIndexChanged">
                                                                    <asp:ListItem Value="2" Text="-- Tất cả --" Selected="True"></asp:ListItem>
                                                                    <asp:ListItem Value="0" Text="- Chưa giải quyết"></asp:ListItem>
                                                                    <asp:ListItem Value="3" Text="  + Chưa thụ lý"></asp:ListItem>
                                                                    <asp:ListItem Value="4" Text="  + Đã thụ lý, chưa giải quyết"></asp:ListItem>
                                                                    <asp:ListItem Value="1" Text="- Đã giải quyết"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </td>
                                                        <td>Từ ngày</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTrangthai_tungay" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtTrangthai_tungay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtTrangthai_tungay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator6" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTrangthai_tungay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                        <td>Đến ngày</td>
                                                        <td>
                                                            <asp:TextBox ID="txtTrangthai_denngay" runat="server" CssClass="user" Width="101px" MaxLength="10"></asp:TextBox>
                                                            <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtTrangthai_denngay" Format="dd/MM/yyyy" Enabled="true" />
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender13" runat="server" TargetControlID="txtTrangthai_denngay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                            <cc1:MaskedEditValidator ID="MaskedEditValidator7" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTrangthai_denngay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 101px;">Thẩm phán</td>
                                                        <td>
                                                            <div style="width: 242px;">
                                                                <asp:DropDownList ID="ddlTimkiem_Thamphan" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="242px">
                                                                    <asp:ListItem Value="0" Text="-- Tất cả --" Selected="True"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </td>
                                                        <td style="width: 101px;">Thư ký</td>
                                                        <td>
                                                            <div style="width: 242px;">
                                                                <asp:DropDownList ID="ddlTimkiem_Thuky" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="242px">
                                                                    <asp:ListItem Value="0" Text="-- Tất cả --" Selected="True"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">
                                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="cmdTimkiem_Click" OnClientClick="return validateSearch();" />
                                        <asp:Button ID="cmdInDanhsach" runat="server" CssClass="buttoninput" Text="In danh sách" OnClick="cmdInDanhsach_Click" />
                                        <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                        <div class="phantrang" id="ptT" runat="server">
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
                                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4" PageSize="10" AllowPaging="True" GridLines="None"
                                            PagerStyle-Mode="NumericPages" CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%" OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>TT</HeaderTemplate>
                                                    <ItemTemplate><%# Container.DataSetIndex + 1 %></ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Chọn</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="chkChon" AutoPostBack="true" ToolTip='<%#Eval("KHANGCAO_SOTHAM_ID")%>' OnCheckedChanged="chkChon_CheckedChanged" runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>

                                                <asp:TemplateColumn HeaderStyle-Width="242px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>
                                                        Thông tin vụ việc
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("THONGTINVUVIEC") %>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:BoundColumn DataField="NGUOIKHANGCAO" HeaderText="Người kháng cáo" HeaderStyle-Width="160px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGAYKHANGCAO" HeaderText="Ngày kháng cáo" HeaderStyle-Width="101px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>
                                                        Thụ lý xét KCQH
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("SOTHULY") + "<br/>" + Eval("NGAYTHULY")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>                                                
                                                <asp:BoundColumn DataField="KETQUA" HeaderText="Kết quả" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="100px"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>
                                                        Thao tác
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="lbtGiaiquyet" runat="server" CausesValidation="false" Text="Giải quyết" ForeColor="#0e7eee" CommandName="Giaiquyet" CommandArgument='<%#Eval("ID") +";#"+ Eval("KHANGCAO_SOTHAM_ID")%>'></asp:LinkButton>
                                                        <asp:LinkButton ID="lbtSua" runat="server" CausesValidation="false" Text="Sửa" ForeColor="#0e7eee" CommandName="Sua" CommandArgument='<%#Eval("ID") +";#"+ Eval("KHANGCAO_SOTHAM_ID")%>'></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <HeaderStyle CssClass="header"></HeaderStyle>
                                            <ItemStyle CssClass="chan"></ItemStyle>
                                            <PagerStyle Visible="false"></PagerStyle>
                                        </asp:DataGrid>
                                        <div class="phantrang" id="ptB" runat="server">
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
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Panel>

    <div runat="server" id="modalpopupCapnhat" style="display: none; visibility: hidden;"></div>
    <cc1:ModalPopupExtender ID="mp1" BehaviorID="mp1_Capnhat"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="modalpopupCapnhat"
        PopupDragHandleControlID="id_header"
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 80%; overflow-y:scroll; width: 950px; " >



        <div id="id_header" class="Form_Mover"></div>

        <asp:UpdatePanel runat="server" ID="id_upload_manager">
            <ContentTemplate>

                <asp:HiddenField ID="hddVuViecID" runat="server" Value="0" />
                <asp:HiddenField ID="hddKhangcaoID" runat="server" Value="0" />
                <asp:HiddenField ID="hddThulyid" runat="server" Value="0" />
                <asp:HiddenField ID="hddHdxxid" runat="server" Value="0" />
                <asp:HiddenField ID="hddKetqua" runat="server" Value="0" />

                <div class="header" style="">
                    <div class="head_windowList">
                        <div class="HeadResend">
                            <asp:Label ID="txt_head_judge" runat="server"></asp:Label>
                        </div>
                        <asp:ImageButton ID="cmd_close_window" AlternateText="Thoát" ImageUrl="../../../UI/img/close.png" runat="server" OnClick="btnClose_Click" OnClientClick="javascript:HideModalPopup();"  />
                    </div>
                </div>

                <div class="box_nd">
                    <div class="truong">

                        <div>
                            <h4 class="tleboxchung"><b>THÔNG TIN VỤ VIỆC</b></h4>
                            <div>
                                <table>
                                    <tr>
                                        <td>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 150px;">Toà xét xử sơ thẩm: </td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblToaXetxuSotham" runat="server"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Bản án/ Quyết định: </td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblBaqd" runat="server"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Tên vụ việc:</td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblTenVuAn" runat="server"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Người kháng cáo: </td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblNguoiKhangcao" runat="server"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Ngày kháng cáo: </td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblNgayKhangcao" runat="server"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Nội dung kháng cáo: </td>
                                        <td>
                                            <span style="font-weight: bold; float: left; width: 100%; text-align: left;" id="lblNoidungKhangcao" runat="server"></span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <div>
                            <h4 class="tleboxchung"><b>THỤ LÝ XÉT KHÁNG CÁO QUÁ HẠN</b></h4>
                            <div>
                                <table>
                                    <tr>
                                        <td>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 101px;">Ngày thụ lý<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px; margin-left: 0px;">
                                            <asp:TextBox ID="txtNgaythuly" runat="server" AutoPostBack="true" CssClass="user" Width="250px" MaxLength="10" OnTextChanged="cmdSuggestSoThuly_Click"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtNgaythuly" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtNgaythuly" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 101px;">Số thụ lý<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtSothuly" runat="server" CssClass="user" Width="250px" MaxLength="25"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Cán bộ thụ lý</td>
                                        <td>
                                            <div style="width: 250px;">
                                                <asp:DropDownList ID="ddlCanboThuly" CssClass="chosen-select" runat="server" AutoPostBack="True" Width="250px"></asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Ngày tạo</td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNgaytaoThuly" runat="server" CssClass="user" Width="250px" MaxLength="250" Enabled="false"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Button ID="cmdCapnhatThuly" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhatThuly_Click" />
                                            <asp:Button ID="cmdXoaThuly" runat="server" CssClass="buttoninput" Text="Xoá" OnClick="cmdXoaThuly_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Label runat="server" ID="lbthongBaoUpdateThuly" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </div>

                        <div>
                            <h4 class="tleboxchung"><b>THÔNG TIN NGƯỜI TIẾN HÀNH TỐ TỤNG</b></h4>
                            <div>
                                <table>
                                    <tr>
                                        <td>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 101px;">Vai trò tham gia tố tụng<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <div style="width: 250px;">
                                                <asp:DropDownList ID="ddlTucachTGTT" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="ddlTucachTGTT_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">
                                            <asp:Label runat="server" ID="lbCanboHDXX" Text="Tên thẩm phán"></asp:Label><span class="batbuoc">(*)</span></td>
                                        <td>
                                            <div style="width: 250px;">
                                                <asp:DropDownList ID="ddlCanboHDXX" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </div>
                                        </td>
                                        <td style="width: 101px;">Người phân công</td>
                                        <td>
                                            <div style="width: 250px;">
                                                <asp:DropDownList ID="ddlNguoiphancong" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Ngày được phân công</td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNgayphancong" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgayphancong" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgayphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 101px;">Ngày nhận phân công </td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNhanphancong" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtNhanphancong" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txtNhanphancong" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td style="width: 101px;">Ngày kết thúc</td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNgayketthuc" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayketthuc" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayketthuc" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Button ID="cmdCapnhaHDXX" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhaHDXX_Click" />
                                            <asp:Button ID="cmdLammoiHDXX" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoiHDXX_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Label runat="server" ID="lbthongBaoUpdateHDXX" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td colspan="12">
                                            <asp:Panel runat="server" ID="pndata">
                                                <asp:DataGrid ID="dgList_HDXX" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                                    ItemStyle-CssClass="chan" Width="100%"
                                                    OnItemCommand="dgList_HDXX_ItemCommand" OnItemDataBound="dgList_HDXX_ItemDataBound">
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                TT
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%# Container.DataSetIndex + 1 %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Vai trò tiến hành tố tụng
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("TENVAITRO") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="140px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Họ và tên
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("TENNGUOITHTT") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="NguoiPhanCong" HeaderText="Người phân công" HeaderStyle-Width="140px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYPHANCONG" HeaderText="Ngày phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="NGAYNHANPHANCONG" HeaderText="Ngày nhận phân công" HeaderStyle-Width="75px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderStyle-Width="80px" HeaderStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Ngày tạo, người tạo
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <%#Eval("NGUOITAO") %> <%#Eval("NGAYTAO", "{0:dd/MM/yyyy}") %>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>

                                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                            <HeaderTemplate>
                                                                Thao tác
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <asp:LinkButton ID="lblSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
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
                                            </asp:Panel>
                                        </td>
                                    </tr>


                                </table>
                            </div>
                        </div>

                        <div>
                            <h4 class="tleboxchung"><b>KẾT QUẢ GIẢI QUYẾT KHÁNG CÁO QUÁ HẠN</b></h4>
                            <div>
                                <table>
                                    <tr>
                                        <td>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="boder" style="padding: 10px;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 101px;">Ngày quyết định<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px; margin-left: 0px;">
                                            <asp:TextBox ID="txtNgayQD" runat="server" CssClass="user" Width="250px" MaxLength="10" AutoPostBack="true" OnTextChanged="cmdSuggestSoQD_Click"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtNgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 101px;">Số QĐ<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtSoQD" runat="server" CssClass="user" Width="250px" MaxLength="25"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Lý do KCQH</td>
                                        <td style="width: 250px;" >
                                            <asp:TextBox ID="txtLydoKCQH" runat="server" CssClass="user" Width="250px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Kết quả<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:RadioButtonList ID="rdbChapnhan" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="1" Text="Chấp nhận"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Không chấp nhận"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Đình chỉ"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Ngày giải quyết<span class="batbuoc">(*)</span></td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNgaygiaiquyet" runat="server" CssClass="user" Width="250px" MaxLength="10"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgaygiaiquyet" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgaygiaiquyet" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Ngày tạo</td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtNgaytaoKetqua" runat="server" CssClass="user" Width="250px" MaxLength="250" Enabled="false"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 101px;">Ghi chú</td>
                                        <td style="width: 250px;">
                                            <asp:TextBox ID="txtGQGhichu" runat="server" CssClass="user" Width="250px" MaxLength="250" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Button ID="cmdCapnhatKetqua" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdCapnhatKetqua_Click" />
                                            <asp:Button ID="cmXoaKetqua" runat="server" CssClass="buttoninput" Text="Xoá" OnClick="cmdXoaKetqua_Click" />
                                            <asp:Button ID="cmdInQuyetdinh" runat="server" CssClass="buttoninput" Text="In Quyết định" OnClick="cmdInQuyetDinh_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center;" colspan="6">
                                            <asp:Label runat="server" ID="lbthongBaoUpdateKetqua" ForeColor="Red"></asp:Label>
                                        </td>
                                    </tr>

                                </table>
                            </div>
                        </div>

                        <div>
                            <div>
                                <table>
                                    <tr>
                                        <td style="text-align: left;" colspan="6">
                                            <asp:Button ID="btnClose" runat="server" CssClass="buttoninput" Text="Đóng" OnClick="btnClose_Click" OnClientClick="javascript:HideModalPopup();" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>


    </asp:Panel>

    <script type="text/javascript">
        function validateSearch() {
            var txtTuNgay = document.getElementById('<%=txtTuNgay.ClientID%>');
            var lengthTuNgay = txtTuNgay.value.trim().length;
            var TuNgay;
            if (lengthTuNgay > 0) {
                var arr = txtTuNgay.value.split('/');
                TuNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                if (TuNgay.toString() == "NaN" || TuNgay.toString() == "Invalid Date") {
                    alert('Bạn phải nhập kháng cáo từ ngày theo định dạng (dd/MM/yyyy).');
                    txtTuNgay.focus();
                    return false;
                }
            }
            var txtDenNgay = document.getElementById('<%=txtDenNgay.ClientID%>');
                var lengthDenNgay = txtDenNgay.value.trim().length;
                var DenNgay;
                if (lengthDenNgay > 0) {
                    var arr = txtDenNgay.value.split('/');
                    DenNgay = new Date(arr[2] + '-' + arr[1] + '-' + arr[0]);
                    if (DenNgay.toString() == "NaN" || DenNgay.toString() == "Invalid Date") {
                        alert('Bạn phải nhập kháng cáo đến ngày theo định dạng (dd/MM/yyyy).');
                        txtDenNgay.focus();
                        return false;
                    }
                }
                if (lengthTuNgay > 0 && lengthDenNgay > 0 && TuNgay > DenNgay) {
                    alert('Ngày kháng cáo từ ngày phải nhỏ hơn đến ngày.');
                    txtDenNgay.focus();
                    return false;
                }
                return true;
        }

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            $('.chosen-container-single').css('width', '100%');
        }
    </script>

    <script type="text/javascript">
        function HideModalPopup() {
            $find("mp1_Capnhat").hide();
            return false;
        }
    </script>
</asp:Content>
