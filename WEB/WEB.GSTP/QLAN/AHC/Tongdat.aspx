<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Tongdat.aspx.cs" Inherits="WEB.GSTP.QLAN.AHC.Tongdat" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="/UI/js/base64.js"></script>
    <script type="text/javascript" src="/UI/js/vgcaplugin.js"></script>
    <script type="text/javascript" src="/UI/js/Common.js"></script>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddIsTructuyen" Value="0" runat="server" />
    <asp:HiddenField ID="hddarrDuongsuTructuyen" Value="" runat="server" />
    <asp:HiddenField ID="CountItem" Value="" runat="server" />
    <asp:HiddenField ID="Sothongbao" Value="" runat="server" /> <%--// vnpt 03/12/2025--%>
    <style type="text/css">
        .opacity_1 {
            opacity: 1;
        }

        .opacity_0_2 {
            opacity: 0.2;
        }

        .btn_add_remove {
            border-radius: 50%;
            background-color: red;
            color: white;
            border: hidden;
            width: 20px;
            height: 20px;
            font: 25px;
            padding-top: unset;
            font-size: 20px;
        }

        .marinleft {
            margin-left: 15px
        }

        .floatleft {
            float: left
        }

        .red-text {
            color: red;
        }

        .cus_pd_left {
            padding-left: 4px;
        }

        .cus_input {
            border: solid 1px #cccccc;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #044271;
            padding: 4px 3px;
            text-indent: 3px;
        }

        .cus_border_left {
            border-top: solid 1px #a2c2a8 !important;
            border-right: solid 1px #a2c2a8 !important;
            border-bottom: solid 1px #a2c2a8 !important;
            border-left: none !important;
        }

        .cus_border_right {
            border-top: solid 1px #a2c2a8 !important;
            border-left: solid 1px #a2c2a8 !important;
            border-bottom: solid 1px #a2c2a8 !important;
            border-right: none !important;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="boxchung">
                <h4 class="tleboxchung">Thông tin tống đạt</h4>
                <div class="boder" style="padding: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="width: 160px;">Hình thức nộp đơn khởi kiện</td>
                            <td colspan="3">
                                <b>
                                    <asp:Literal ID="lstHinhthucgui" runat="server"></asp:Literal></b>
                            </td>
                        </tr>
                        <tr>
                            <td>Đăng ký nhận tống đạt qua hệ thống ĐKK?</td>
                            <td colspan="3">
                                <b>
                                    <asp:Literal ID="lstDKNhanTD" runat="server"></asp:Literal></b>
                            </td>
                        </tr>
                        <tr>
                            <td>Văn bản tống đạt<span class="batbuoc">(*)</span></td>
                            <td colspan="3">
                                <div style="width: 380px; float: left;">
                                    <asp:DropDownList ID="ddlBieumau" CssClass="chosen-select" runat="server" Width="661px" OnSelectedIndexChanged="ddlBieumau_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Literal ID="lstTenBM" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                        <tr id="trFile" runat="server">
                            <td>Tệp đính kèm gửi trực tuyến</td>
                            <td colspan="3">
                                <div runat="server" id="trThemFile" visible="false">
                                    <asp:HiddenField ID="hddFilePath" runat="server" />
                                    <asp:CheckBox ID="chkKySo" Checked="false" runat="server" onclick="CheckKyso();" Text="Sử dụng ký số file đính kèm" />
                                    <br />
                                    <asp:HiddenField ID="hddFileKySo" runat="server" Value="" />
                                    <asp:HiddenField ID="hddSessionID" runat="server" />
                                    <asp:HiddenField ID="hddURLKS" runat="server" />
                                    <div id="zonekyso" style="margin-bottom: 5px; margin-top: 10px; float: left;">
                                        <button type="button" class="buttonkyso" id="TruongPhongKyNhay" onclick="exc_sign_file1();">Chọn file đính kèm và ký số</button>
                                        <button type="button" class="buttonkyso" id="_Config" onclick="vgca_show_config();">Cấu hình CKS</button><br />
                                        <ul id="file_name" style="list-style: none; margin: 0px 0px 0px 0px; padding: 0px 0px 0px 0px; line-height: 18px;">
                                        </ul>
                                    </div>
                                    <div id="zonekythuong" style="display: none; float: left; margin-top: 10px; width: 80%;">
                                        <cc1:AsyncFileUpload ID="AsyncFileUpLoad" runat="server" CompleteBackColor="Lime" UploaderStyle="Modern" OnUploadedComplete="AsyncFileUpLoad_UploadedComplete"
                                            ErrorBackColor="Red" ThrobberID="Throbber" UploadingBackColor="#66CCFF" Width="300px" Height="45px" CssClass="upload_kythuong" />
                                        <asp:Image ID="Throbber" runat="server" ImageUrl="~/UI/img/loading-gear.gif" CssClass="img_load_file" />
                                    </div>
                                    <br />
                                </div>
                                <style>
                                    /*20/11/2024*/
                                    .upload_kythuong {
                                        position: relative;
                                        top: 20px;
                                        left: 0px;
                                    }

                                        .upload_kythuong input {
                                            height: 25px;
                                            position: absolute;
                                            left: 0px;
                                            top: 2px;
                                        }

                                    .img_load_file {
                                        /*position: absolute;
                                                top: -3px;*/
                                    }
                                </style>
                                <asp:HiddenField ID="hddFile" Value="0" runat="server" />
                                <asp:LinkButton ID="lbtDownload" Visible="false" runat="server" Text="Tải file đính kèm" OnClick="lbtDownload_Click"></asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                        </tr>
                        <tr runat="server" id="trVKS">
                            <td style="width: 160px;">+ Tống đạt tới Viện kiểm sát?</td>
                            <td style="width: 200px;">
                                <asp:RadioButtonList ID="rdbIsVKS" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdbIsVKS_SelectedIndexChanged">
                                    <asp:ListItem Value="0" Selected="True">Không gửi</asp:ListItem>
                                    <asp:ListItem Value="1">Có gửi</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>

                            <td style="text-align: right; width: 65px;">
                                <asp:Label ID="lblVKSNgaygui" Visible="false" runat="server" Text="Ngày gửi"></asp:Label>
                            </td>

                            <td>
                                <div style="float: left;">
                                    <asp:TextBox ID="txtVKS_Ngaygui" runat="server" Visible="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtVKS_Ngaygui" Format="dd/MM/yyyy" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtVKS_Ngaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                </div>
                                <div id="div_VKS_NgayNhan" runat="server" visible="false" style="float: left; width: 65px; margin-left: 10px; margin-top: 7px;">Ngày nhận</div>
                                <div>
                                    <asp:TextBox ID="txtVKS_NgayNhan" runat="server" Visible="false" CssClass="user" Width="90px" MaxLength="10"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtVKS_NgayNhan" Format="dd/MM/yyyy" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtVKS_NgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;<span>Ủy thác tư pháp</span>
                                    <asp:CheckBox ID="cb_uttp" runat="server" AutoPostBack="true" OnCheckedChanged="Unnamed_CheckedChanged" />
                                </div>
                            </td>


                        </tr>

                        <tr runat="server" id="trDuongsu" visible="false">

                            <td style="width: 160px;">+ Tống đạt tới các đương sự qua phương thức trực tiếp, bưu điện,...?</td>
                            <td colspan="3">
                                <asp:DataGrid EditItemStyle-Wrap="false" ID="dgTructiep" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="1100px" OnItemDataBound="dgTructiep_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TUCACHTOTUNG_MA" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="HINHTHUCGUI" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="QUOCGIA" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="COQUAN" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NOIDUNG" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="KETQUAUTTP" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TONGDAT_DOITUONG" Visible="false"></asp:BoundColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Nơi nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lbTenDuongSu" Text='<%#Eval("TENDUONGSU") %>'></asp:Label>
                                                <div style="float: left">
                                                    <asp:TextBox CssClass="floatleft cus_input" Width="75%" Height="21px" ID="txtNoiNhan" Enabled ="false" Visible="false" runat="server" />
                                                    <asp:DropDownList Visible="false" CssClass="floatleft cus_input" Height="31px" Width="24px" runat="server" AutoPostBack="true" ID="ddlNoiNhan" OnSelectedIndexChanged="ddlNoiNhan_SelectedIndexChanged" Style="margin-left: 2px" />
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                            <HeaderTemplate>
                                                Tư cách tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label Visible="true" runat="server" ID="lbTenTCTT"></asp:Label>
                                                <asp:DropDownList Visible="false" Width="100%" Height="30px" CssClass="cus_input" runat="server" ID="ddlTCTT" Enabled ="false" AutoPostBack="true"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                            <HeaderTemplate>
                                                Số thông báo
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" Visible="true" ID="lbSothongbao"><%#Eval("SOTHONGBAO")%></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn ItemStyle-Width="120px" HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Địa chỉ 
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" Visible="true" ID="lbDiaChi"><%#Eval("DIACHI") %></asp:Label>
                                                <asp:TextBox Width="95%" ID="txtDiachi" Text='<%#Eval("DIACHI") %>' CssClass="cus_input" Height="20px" Visible="false" runat="server"></asp:TextBox>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                            <HeaderTemplate>
                                                Đối tượng Tống đạt
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkIsSend" runat="server" Checked='<%# GetNumber(Eval("TRANGTHAI"))%>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkIsSend_CheckChange" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Ngày gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgaygui" Visible="false" runat="server" Text='<%# GetTextDate(Eval("NGAYGUI"))%>' CssClass="cus_input" Width="92%" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaygui_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgaygui_CalendarExtender" runat="server" TargetControlID="txtNgaygui" Format="dd/MM/yyyy" />
                                                <cc1:MaskedEditExtender ID="txtNgaygui_MaskedEditExtender3" runat="server" TargetControlID="txtNgaygui" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Ngày phát hành
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgayphathanh" Enabled="false" Text='<%# GetTextDate(Eval("NGAYPHATHANH"))%>' Visible="true" runat="server" CssClass="cus_input" Width="92%" MaxLength="10" AutoPostBack="true" OnTextChanged="txtNgaygui_SelectedIndexChanged"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayphathanh_CalendarExtender" runat="server" TargetControlID="txtNgayphathanh" Format="dd/MM/yyyy" />
                                                <cc1:MaskedEditExtender ID="txtNgayphathanh_MaskedEditExtender3" runat="server" TargetControlID="txtNgayphathanh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="70px">
                                            <HeaderTemplate>
                                                Ngày nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtNgayNhan" Visible="false" runat="server" Text='<%# GetTextDate(Eval("NGAYNHANTONGDAT"))%>' CssClass="cus_input" Width="92%" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="txtNgayNhan_CalendarExtender" runat="server" TargetControlID="txtNgayNhan" Format="dd/MM/yyyy" />
                                                <cc1:MaskedEditExtender ID="txtNgayNhan_MaskedEditExtender3" runat="server" TargetControlID="txtNgayNhan" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="True" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                            <HeaderTemplate>
                                                Tống đạt qua VNeID
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkIsXACTHUC_DLDCQG" runat="server" Checked='<%# (Eval("XACTHUC_DLDCQG") != null && Eval("XACTHUC_DLDCQG").ToString() == "1") ? true : false %>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' Enabled="false"/>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Hình thức gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlHinhthuc" Visible="true" CssClass="chosen-select user" runat="server" Width="100px" AutoPostBack="True" OnSelectedIndexChanged="ddlHinhthuc_SelectedIndexChanged">
                                                    <asp:ListItem Value="2" Text="Qua bưu điện" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Thừa phát lại"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Niêm yết công khai"></asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                UTTP
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlUTTP" Visible="true" CssClass="chosen-select" runat="server" Width="100px" AutoPostBack="True" OnSelectedIndexChanged="ddlUTTP_SelectedIndexChanged">
                                                    <asp:ListItem Value="3" Text="Tự UTTP" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="Cấp trên UTTP"></asp:ListItem>
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" Visible="false" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="40px">
                                            <HeaderTemplate>
                                                Thông tin ủy thác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div style="display: flex">
                                                    <span style="width: 60px">
                                                        <asp:Label ID="lblQuocGia" Text="Quốc gia<span style='color:red'>*</span>" runat="server" /></span>
                                                    <span>
                                                        <asp:DropDownList ID="ddlQuocGiaUT" CssClass="chosen-select" runat="server" Width="150px" AutoPostBack="True" OnSelectedIndexChanged="ddlQuocGiaUT_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </span>
                                                </div>
                                                <div style="display: flex; margin-top: 5px">
                                                    <span style="width: 60px">
                                                        <asp:Label ID="lblCoquan" Text="Cơ quan<span style='color:red'>*</span>" runat="server" /></span>
                                                    <span>
                                                        <asp:TextBox ID="txtCoquan" TextMode="multiline" runat="server" Text='' CssClass="user" Width="140px"></asp:TextBox></span>
                                                </div>
                                                <div style="display: flex">
                                                    <span style="width: 60px">
                                                        <asp:Label ID="lblNoidung" Text="Nội dung" runat="server" /></span>
                                                    <span>
                                                        <asp:TextBox ID="txtNoidung" TextMode="multiline" CssClass="user" Width="140px" Columns="50" Rows="1" runat="server" /></span>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn Visible="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                                            <HeaderTemplate>
                                                Kết quả UTTP
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="ddlketquauttp" CssClass="chosen-select" runat="server" Width="120px" AutoPostBack="True" OnSelectedIndexChanged="ddlketquauttp_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:TemplateColumn Visible="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Button BackColor="Red" CssClass="btn_add_remove" runat="server" ID="btn_insert" Text="+" OnClick="btn_insert_Click" />

                                                <asp:Button runat="server" CssClass="btn_add_remove" ID="btn_remove" Text="-" OnClick="btn_remove_Click" />
                                                <%--<div class="tooltip" style="margin-top:3px;">
                                                        <asp:ImageButton ID="btn_insert" runat="server" ToolTip="Thêm" CssClass="grid_button" OnClick="btn_insert_Click1"
                                                            ImageUrl="~/UI/img/new.png" Width="18px" />
                                                        <span class="tooltiptext  tooltip-bottom">Thêm</span>
                                                    </div>
                                                    <div class="tooltip" style="margin-top:3px;">
                                                        <asp:ImageButton ID="btn_remove" runat="server" ToolTip="Xóa" CssClass="grid_button"
                                                            ImageUrl="~/UI/img/delete.png" Width="17px"
                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa? ');" OnClick="btn_remove_Click1"/>
                                                        <span class="tooltiptext  tooltip-bottom">Xóa</span>
                                                    </div>--%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TENDUONGSU" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="DUONGSUID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TRANGTHAI" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="ANPHI_ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="SOTHONGBAO" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="MA_THONGBAO" Visible="false"></asp:BoundColumn>
                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="border-bottom: dotted 1px #dcdcdc; padding-bottom: 2px;"></td>
                        </tr>
                        <tr runat="server" id="trTructuyen" visible="false">
                            <td>+ Tống đạt tới các đương sự qua phương thức trực tuyến?
                            </td>
                            <td colspan="3">
                                <asp:DataGrid ID="dgTructuyen" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="661px" OnItemDataBound="dgTructuyen_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TUCACHTOTUNG_MA" Visible="false"></asp:BoundColumn>

                                        <asp:TemplateColumn HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# Container.DataSetIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Tên đương sự
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENDUONGSU") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="110px">
                                            <HeaderTemplate>
                                                Tư cách tố tụng
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%#Eval("TENTCTT") %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                            <HeaderTemplate>
                                                Đối tượng Tống đạt
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkIsSendTT" runat="server" Checked='<%# GetNumber(Eval("TRANGTHAI"))%>' AutoPostBack="true" ToolTip='<%#Eval("ID")%>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="100px">
                                            <HeaderTemplate>
                                                Ngày gửi / nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# GetTextDate(Eval("NGAYGUI"))%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                    </Columns>
                                    <HeaderStyle CssClass="header"></HeaderStyle>
                                    <ItemStyle CssClass="chan"></ItemStyle>
                                    <PagerStyle Visible="false"></PagerStyle>
                                </asp:DataGrid>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <div>
                                    <asp:HiddenField ID="hddid" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddNguoiKyID" runat="server" Value="0" />
                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput" Text="Lưu và gửi" OnClick="btnUpdate_Click" />
                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="btnLammoi_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="boxchung">
                <h4 class="tleboxchung">Các văn bản đã tống đạt</h4>
                <div class="boder" style="padding: 10px;">
                    <asp:Button Text="Gửi sang VBĐH" ID="VBDH" OnClick="VBDH_Click" CssClass="buttoninput" runat="server" />
                    <asp:Button Text="Phát hành bổ sung" ID="PHBS" OnClick="PHBS_Click" CssClass="buttoninput marinleft" runat="server" />
                    <asp:Button Text="Sửa" ID="btnSua" OnClick="btnSua_Click" CssClass="buttoninput marinleft" runat="server" />
                    <asp:Button ID="btnXoa" OnClick="btnXoa_Click" Text="Xóa" CssClass="buttoninput marinleft" runat="server" />
                    <br />
                    <div style="margin-top: 20px">
                        <asp:Label runat="server" ID="lbThongBaoThuHoi" ForeColor="Red"></asp:Label>
                        <table style="margin-top: 10px">
                            <tr>
                                <td>Ngày thu hồi&emsp;
                                </td>
                                <td>
                                    <asp:TextBox CssClass="cus_pd_left" Height="26px" Width="100px" runat="server" ID="txbNgayThuHoi"></asp:TextBox>&emsp;
                                    <cc1:CalendarExtender ID="CalendarExtenderTH2" runat="server" TargetControlID="txbNgayThuHoi" Format="dd/MM/yyyy" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtenderTH3" runat="server" TargetControlID="txbNgayThuHoi" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" />
                                </td>
                                <td>Lý do thu hồi&emsp;
                                </td>
                                <td>
                                    <asp:TextBox CssClass="cus_pd_left" Height="26px" Width="300px" runat="server" ID="txtLyDoThuHoi"></asp:TextBox>&emsp;
                                </td>
                                <td>
                                    <asp:Button ID ="btnThuHoi" Text="Thu hồi" runat="server" CssClass="buttoninput" OnClick="Unnamed_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>

                    <table class="table1">
                        <tr>
                            <td>
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
                                    PageSize="20" AllowPaging="True" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TONGDATID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="DUONGSUID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NOINHAN" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TRANGTHAI" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="IS_SUA" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="XACTHUC_DLDCQG" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="10px">
                                            <HeaderTemplate></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="cb_thuhoi" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="25px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                TT
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lbTT"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-CssClass="cus_border_right" ItemStyle-CssClass="cus_border_right" HeaderStyle-Width="260px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Văn bản
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lbTenBM"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-CssClass="cus_border_left" ItemStyle-CssClass="cus_border_left" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="30px">
                                            <HeaderTemplate></HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:ImageButton Width="15px" ID="lblDownload" ImageUrl="~/UI/img/file_icon.png" runat="server" CausesValidation="false" CommandName="Download" CommandArgument='<%#Eval("TONGDATID") %> ' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="140px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Nơi nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:Label runat="server" ID="lbNoiNhan"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# String.Format("{0:dd/MM/yyyy}",Eval("NGAYGUI")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày phát hành
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# String.Format("{0:dd/MM/yyyy}",Eval("NGAYPHATHANH")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="170px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày nhận
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                            <%--    <%# String.Format("{0:dd/MM/yyyy}",Eval("NGAYNHANTONGDAT")) %>--%>
                                                 <asp:TextBox ID="txtNGAYNHANTONGDAT" runat="server" CssClass="user"
                                                    Width="70px" MaxLength="10" placeholder="..../..../....."
                                                    Text='<%#GetTextDate(Eval("NGAYNHANTONGDAT")) %>'></asp:TextBox>
                                                <cc1:CalendarExtender ID="CE_PCLD" runat="server" TargetControlID="txtNGAYNHANTONGDAT" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="ME_PCLD" runat="server" TargetControlID="txtNGAYNHANTONGDAT" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                <asp:Button ID="cmdUpdate_NgayNhan" ToolTip="Lưu" runat="server" CssClass="buttoninput" CommandName="UpdateNgayNhan" 
                                                     CommandArgument='<%#Eval("ID")%>' Text="Lưu" Height="26px" />
                                                <style>
                                                    .txt_ngay_nhan_Dis {
                                                        width: 120px;
                                                        border: unset;
                                                    }

                                                    .txt_ngay_nhan {
                                                        border: 1px solid #f1a835 !important;
                                                        width: 120px;
                                                    }

                                                    .btn_ngaynhan_Dis {
                                                        min-width: 40px;
                                                        background: #e6e6e0;
                                                        color: #696868;
                                                    }

                                                    .btn_ngaynhan {
                                                        min-width: 40px;
                                                        background-color: unset;
                                                    }
                                                </style>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Trạng thái/ Hình thức gửi
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <div><i>Trạng thái:</i>   <b>
                                                    <asp:Label runat="server" ID="lbTrangThai"></asp:Label></b></div>
                                                <div><i>Hình thức gửi:</i> <b>
                                                    <asp:Label runat="server" ID="lbtHinhthucgui"></asp:Label></b></div>
                                                <asp:HiddenField ID="Hi_column_value" Value='<%#Eval("NGAYGUI")+";"+Eval("NGAYPHATHANH") +";"+Eval("HINHTHUCGUI")%>' runat="server" />
                                                 <div><i>Tống đạt qua VNeID:</i>   <b>
                                                    <asp:Label runat="server" ID="lbVNeID"></asp:Label></b></div>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <%--<asp:BoundColumn DataField="NGUOITAO" HeaderText="Người tạo" Visible="false" HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="NGAYTAO" HeaderText="Ngày tạo" Visible="false" HeaderStyle-Width="98px" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy HH:mm}"></asp:BoundColumn>--%>
                                        <asp:BoundColumn DataField="TRANGTHAI" Visible="false" HeaderText="Đã nhận/ Tổng số" HeaderStyle-Width="104px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Ngày nhận VNeID
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# String.Format("{0:dd/MM/yyyy HH:mm:ss}",Eval("NGAYGUI_THANHCONG")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thời gian xem
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <%# String.Format("{0:dd/MM/yyyy HH:mm:ss}",Eval("NGAYXEM")) %>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="102px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>
                                                Thao tác
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtn" runat="server" CausesValidation="false" CommandName="action" ForeColor="#0e7eee"
                                                    CommandArgument='<%#Eval("TRANGTHAI") + "#" + Eval("ID") + "#" + Eval("TONGDATID")%>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>

                                        <asp:BoundColumn DataField="MAPID" Visible="false"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TOA_GIAIQUYET_ID" Visible="false"></asp:BoundColumn>
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
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">       

        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
            //   CheckKyso();
        }
        var count_file = 0;
        function CheckKyso() {
            var chkKySo = document.getElementById('<%=chkKySo.ClientID%>');
            if (chkKySo.checked) {
                document.getElementById("zonekyso").style.display = "";
                document.getElementById("zonekythuong").style.display = "none";
            }
            else {
                document.getElementById("zonekyso").style.display = "none";
                document.getElementById("zonekythuong").style.display = "";
            }
        }
        $(document).on('click', '.active-result', function (e) {
            javascript: setTimeout('__doPostBack(\'ctl00$dvSpliter$ContentPlaceHolder1$dgTructiep$ctl03$ddlQuocGiaUT\',\'\')', 0)
        })
        function VerifyPDFCallBack(rv) {

        }
        function exc_verify_pdf1() {
            var prms = {};
            var hddSession = document.getElementById('<%=hddSessionID.ClientID%>');
            prms["SessionId"] = "";
            prms["FileName"] = document.getElementById("file1").value;
            var json_prms = JSON.stringify(prms);
            vgca_verify_pdf(json_prms, VerifyPDFCallBack);
        }
        function SignFileCallBack1(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                var hddFilePath = document.getElementById('<%=hddFilePath.ClientID%>');
                var new_item = document.createElement("li");
                new_item.innerHTML = received_msg.FileName;
                hddFilePath.value = received_msg.FileServer;
                //-------------Them icon xoa file------------------
                var del_item = document.createElement("img");
                del_item.src = '/UI/img/xoa.gif';
                del_item.style.width = "15px";
                del_item.style.margin = "5px 0 0 5px";
                del_item.onclick = function () {
                    if (!confirm('Bạn muốn xóa file này?')) return false;
                    document.getElementById("file_name").removeChild(new_item);
                }
                del_item.style.cursor = 'pointer';
                new_item.appendChild(del_item);

                document.getElementById("file_name").appendChild(new_item);
            } else {
                document.getElementById("_signature").value = received_msg.Message;
            }
        }
        //metadata có kiểu List<KeyValue> 
        //KeyValue là class { string Key; string Value; }
        function exc_sign_file1() {
            var prms = {};
            var scv = [{ "Key": "abc", "Value": "abc" }];
            var hddURLKS = document.getElementById('<%=hddURLKS.ClientID%>');
            prms["FileUploadHandler"] = hddURLKS.value.replace(/^http:\/\//i, window.location.protocol + '//');
            prms["SessionId"] = "";
            prms["FileName"] = "";
            prms["MetaData"] = scv;
            var json_prms = JSON.stringify(prms);
            vgca_sign_file(json_prms, SignFileCallBack1);
        }
        function RequestLicenseCallBack(rv) {
            var received_msg = JSON.parse(rv);
            if (received_msg.Status == 0) {
                document.getElementById("_signature").value = received_msg.LicenseRequest;
            } else {
                alert("Ký số không thành công:" + received_msg.Status + ":" + received_msg.Error);
            }
        }
    </script>
</asp:Content>
