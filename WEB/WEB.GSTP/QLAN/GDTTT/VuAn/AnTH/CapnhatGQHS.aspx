<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="CapnhatGQHS.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.AnTH.CapnhatGQHS" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

   
    <script src="../../../../UI/js/Common.js"></script>
    <asp:HiddenField ID="hddVuAnID" runat="server" Value="0" />
    <asp:HiddenField ID="hddXetXuID" runat="server" Value="0" />
    <asp:HiddenField ID="hddShowHoSoVKS" runat="server" Value="0" />
    <asp:HiddenField ID="hddGUID" runat="server" Value="" />
    <asp:HiddenField ID="hddLoaiAn" runat="server" Value="0" />
    <asp:HiddenField ID="hddNext" runat="server" Value="0" />
    <asp:HiddenField ID="hdd_thamphan" runat="server" Value="" />
    <asp:HiddenField ID="hdd_thamphan_name" runat="server" Value="" />
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
            overflow-y: auto;
            overflow-x: auto;
        }

        .col1 {
            width: 142px;
            font-weight: bold;
        }

        .col2 {
            width: 250px;
        }

        .col3 {
            width: 115px;
            font-weight: bold;
        }
        /*#thongtinvuan .table2 tr td:nth-child(2),#thongtinvuan .table2 tr td:nth-child(4)
        {
            font-weight:bold;
        }*/
        /*#thongtinvuan .table_info_va tr td:nth-child(1), #thongtinvuan .table_info_va tr td:nth-child(3) {
            font-weight: bold;
        }*/

        .title_form {
            float: left;
            margin-bottom: 15px;
            width: 100%;
            position: relative;
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
        }

        .button_themtt {
            min-width: 80px;
            height: 30px;
            font-weight: bold;
            color: #631313;
            background: url("../img/bg_danhsach.png");
            padding-left: 15px;
            padding-right: 15px;
            cursor: pointer;
            border: solid 1px #9e9e9e;
            border-radius: 3px 3px 3px 3px;
            float: left;
            z-index: 1000;
        }

        .table_tt {
            border: none;
            border-collapse: collapse;
            margin: 5px 0;
            width: 100%;
        }

            .table_tt td {
                padding: 5px;
                border: none;
                line-height: 17px;
                text-align: left;
                vertical-align: middle;
            }

        .list_tt {
            margin-left: 16px;
        }

        .bootstrap-duallistbox-container label {
            display: block;
            font-size: 13px;
            font-weight: bold;
        }

        .menubutton {
            color: #ffffff !important;
        }

            .menubutton:hover {
                color: #780707 !important;
                text-decoration: none !important;
            }

        a:hover {
            color: #9e2702;
            text-decoration: none;
        }

        h4, h4 {
            font-size: unset;
        }

        .h1, .h2, .h3, .h4, .h5, .h6, h1, h2, h3, h4, h5, h6 {
            font-weight: bold;
        }

        input.user {
            height: 25px;
        }

        .btn-outline-secondary:hover {
            background-color: #f0baba;
            border-color: #d28c8c;
        }

        .dxsplPane, .dxsplPaneCollapsed {
            box-sizing: unset;
        }

        .row {
            box-sizing: border-box;
        }
       .table2 .tooltip {
            color: #006080;
            display: inline-block;
            position: relative;
            opacity:unset;
        }
       .buttonprintdisable {
        height: 30px;
        font-weight: bold;
        font-size: 11.7px;
        min-width: 80px;
        padding-left: 15px;
        padding-right: 15px;
        cursor: pointer;
        border: solid 1px  #9e9e9e;
        border-radius: 3px 3px 3px 3px;
    }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <div class="boxchung">
                    <!-------------------------------------------------->
                    <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                        <h4 class="tleboxchung">Thông tin vụ án</h4>
                        <div class="boder" style="padding: 2%; width: 96%; background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #ffffff 0%, #fff478 96%); box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                            <table class="table_info_va">
                                <tr>
                                    <td style="width: 110px;">Bị án:</td>
                                    <td colspan="5" style="vertical-align: top;"><b>
                                        <asp:Literal ID="lttVuAn" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số thụ lý:</td>
                                    <td style="width: 250px;"><b>
                                        <asp:Literal ID="txtVuAn_SoThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                    <td style="width: 110px">Ngày thụ lý:</td>
                                    <td colspan="5"><b>
                                        <asp:Literal ID="txtVuAn_NgayThuLy" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số BA/QĐ:</td>
                                    <td><b>
                                        <asp:Literal ID="txtVuAn_SoBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                    <td>Ngày BA/QĐ:</td>
                                    <td colspan="5"><b>
                                        <asp:Literal ID="txtVuAn_NgayBanAn" runat="server"></asp:Literal></b>
                                    </td>
                                </tr>
                                
                                <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                            </table>
                        </div>
                    </div>
                      <!-------------------------------------------------->
                    <asp:Panel ID="pnKLCA" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin giải quyết của TA</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Số Tờ trình CTN<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtSoTT" CssClass="user" runat="server" Width="200px" Enabled="false"></asp:TextBox>                                         
                                        </td>
                                        <td style="width: 110px;">Ngày TT<span class="batbuoc">*</span></td>
                                        <td  style="width: 200px;">
                                            <asp:TextBox ID="txtNgayTT" CssClass="user" runat="server" Width="200px" Enabled="false"></asp:TextBox> 
                                        </td>
                                        <td>Nội dung trình<span class="batbuoc"></span></td>
                                        <td  style="width: 450px;">  
                                            <asp:TextBox ID="txtNoidungTT" CssClass="user" runat="server" Width="215px" Enabled="false"></asp:TextBox> 
                                        </td>
                                     </tr>
                                     <tr>
                                        <td style="width: 110px;">Số QĐCA<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtSOQD_CA" CssClass="user" runat="server" Width="200px"></asp:TextBox>                                         
                                        </td>
                                        <td style="width: 110px;">Ngày QĐ<span class="batbuoc">*</span></td>
                                        <td  style="width: 200px;" >
                                            <asp:TextBox ID="txtNgayQD_CA" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNgayQD_CA_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender7" runat="server" TargetControlID="txtNgayQD_CA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender7" runat="server" TargetControlID="txtNgayQD_CA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                         <td>Kết luận của CA<span class="batbuoc">*</span></td>
                                        <td  style="width: 450px;">  
                                             <asp:DropDownList ID="ddlKETLUAN_CA" CssClass="chosen-select" runat="server" Width="215px">
                                                <asp:ListItem Value="0" Text="---Chọn---" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Không Kháng nghị"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                             </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Nội dung</td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtNOIDUNG_QD_CA" CssClass="user" runat="server" Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>
                                 
                                     <tr>
                                        <td style="width: 110px;">Ngày chuyển CV/HS<span class="batbuoc">*</span></td>
                                        <td colspan="5">
                                            <asp:TextBox ID="txtNGAYPHCV_VKS" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNGAYPHCV_VKS_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtNGAYPHCV_VKS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtNGAYPHCV_VKS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td> 
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Ghi chú CV gửi</td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtGHICHUCV_GUI" CssClass="user" runat="server" Width="532px"></asp:TextBox>
                                        </td> 
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpdateCA" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateCA_Click" OnClientClick="return validate_qd_ca();" />
                                            <asp:Button ID="cmdDelete_CA" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdDelete_CA_Click" OnClientClick="return delete_qd_ca();" />
                                        </td>
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label1" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                   
                    <!-------------------------------------------------->
                    <asp:Panel ID="pnKLVKS" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin giải quyết của VKS</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        
                                        <td style="width: 110px;">Số QĐ<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtSOQD_VKS" CssClass="user" runat="server"
                                                Width="200px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày QĐ<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNGAYQD_VKS" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNGAYQD_VKS_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNGAYQD_VKS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNGAYQD_VKS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 110px;">Kết luận VKS<span class="batbuoc">*</span></td>
                                        <td style="width: 450px;">
                                            <asp:DropDownList ID="ddlKETLUAN_VKS" CssClass="chosen-select" runat="server" Width="215px">
                                               <asp:ListItem Value="0" Text="--Chọn---" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Không Kháng nghị"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Kháng nghị"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Số Tờ trình<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtSoTT_VKS" CssClass="user" runat="server"
                                                Width="200px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày Tờ trình<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtNGAYTT_VKS" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNGAYTT_VKS_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender11" runat="server" TargetControlID="txtNGAYTT_VKS" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender11" runat="server" TargetControlID="txtNGAYTT_VKS" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td style="width: 110px;">Nội dung trình<span class="batbuoc">*</span></td>
                                        <td  style="width: 450px;">
                                           
                                            <asp:DropDownList ID="ddlNoidungTT_VKS" CssClass="chosen-select" runat="server" Width="215px">
                                               <asp:ListItem Value="0" Text="--Chọn---" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Bác đơn"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Ân giảm"></asp:ListItem>
                                               
                                            </asp:DropDownList>
                                           </td>
                                        </tr>
                                    <tr>
                                        <td style="width: 110px;">Ghi chú VKS </td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtGHICHU_VKS_TRA" CssClass="user" runat="server" Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpdateVKS" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateVKS_Click" OnClientClick="return validate_qd_vks();" />
                                            <asp:Button ID="cmdXoa_VKS" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_VKS_Click" OnClientClick="return delete_qd_vks();" />
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="lttMsgHSKN_VKS" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                    <!-------------------------------------------------->
             
                    <asp:Panel ID="pnCTN" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin giải quyết của VP Chủ Tịch Nước</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Kết luận CTN<span class="batbuoc">*</span></td>
                                        <td style="width: 210px;">
                                            <asp:DropDownList ID="ddlCTN_LOAIQD" CssClass="chosen-select" runat="server" Width="210px">
                                               <asp:ListItem Value="0" Text="--Chọn--" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Bác đơn"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Giảm án"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 110px;">Số QĐ<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtCTN_SOQĐ" CssClass="user" runat="server"
                                                Width="200px"></asp:TextBox>

                                        </td>
                                        <td style="width: 110px;">Ngày QĐ<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtCTN_NGAYQD" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtCTN_NGAYQD_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtCTN_NGAYQD" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtCTN_NGAYQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Ngày trả<span class="batbuoc">*</span></td>
                                        <td>
                                            <asp:TextBox ID="txtCTN_NGAYTRA" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtCTN_NGAYTRA_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtCTN_NGAYTRA" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtCTN_NGAYTRA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                       
                                        <td style="width: 110px;">Ghi chú</td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtCTN_GHICHU" CssClass="user" runat="server" Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpdateCTN" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateCTN_Click" OnClientClick="return validate_qd_ctn();" />
                                            <asp:Button ID="cmdXoa_CTN" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdXoa_CTN_Click"
                                                OnClientClick="return delete_qd_ctn();" />
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label2" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>          
                     <!-------------------------------------------------->
       
                    <asp:Panel ID="pnCVXM" runat="server">
                         <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin xác minh</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Số CVXM <span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtSOCVXM" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        </td>
                                         <td style="width: 110px;">Ngày CV<span class="batbuoc">*</span></td>
                                        <td colspan="3">
                                            <asp:TextBox ID="txtNGAYCVXM" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNGAYCVXM_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender12" runat="server" TargetControlID="txtNGAYCVXM" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender12" runat="server" TargetControlID="txtNGAYCVXM" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                       <td style="width: 110px;">Nội dung xác minh</td>
                                        <td style="width: 800px;" colspan="5">
                                            <asp:TextBox ID="txtNoidungXM" CssClass="user" runat="server"
                                                Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpateCVXM" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpateCVXM_Click" OnClientClick="return validate_cvxm();" />
                                            <asp:Button ID="cmdDeleteCVXM" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdDeleteCVXM_Click" OnClientClick="return delete_cvxm();" />
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label3" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
</asp:Panel>  
                    
                    <asp:Panel ID="pnKQXM" runat="server">
                         <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Kết quả xác minh</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Kết quả xác minh<span class="batbuoc">*</span></td>
                                        <td style="width: 210px;">
                                             <asp:DropDownList ID="ddlLoaiKQXM" CssClass="chosen-select" runat="server" Width="210px">
                                                 <asp:ListItem Value="0" Text="---Chọn----" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Đúng thông tin bị án"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Không Đúng thông tin bị án"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 110px;">Ngày có kết quả<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;"  colspan="3">
                                            <asp:TextBox ID="txtNgayKQXM" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtNgayKQXM_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayKQXM" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayKQXM" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                    </tr>
                                    <tr>
                                       <td style="width: 110px;">Nội dung</td>
                                        <td style="width: 800px;" colspan="5">
                                            <asp:TextBox ID="txtKetquaXM" CssClass="user" runat="server"
                                                Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpdate_KQXM" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdate_KQXM_Click" OnClientClick="return validate_kqxm();" />
                                            <asp:Button ID="cmdDelete_KQXM" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdDeleteKQXM_Click"  OnClientClick="return delete_kqxm();"/>
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label4" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>

                    </asp:Panel>  
                    <!-------------------------------------------------->
             
                    <asp:Panel ID="pnCVTHA" runat="server">
                        <div style="float: right; margin-bottom: 10px; width: 100%; position:center">
                            <h4 class="tleboxchung">Kết quả THA</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">                              
                                    <tr>
                                        <td style="width: 110px;">Kết quả THA<span class="batbuoc">*</span></td>
                                        <td style="width: 210px;">
                                             <asp:DropDownList ID="ddlTHA_KETQUA" CssClass="chosen-select" runat="server" Width="210px">
                                               <asp:ListItem Value="0" Text="--Chọn---" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Đã thi hành án"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Đã chết"></asp:ListItem>
                                            </asp:DropDownList>

                                        </td>
                                        <td style="width: 110px;">Ngày THA<span class="batbuoc">*</span></td>
                                        <td style="width: 800px;"  colspan="3">
                                            <asp:TextBox ID="txtTHA_NGAY" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtTHA_NGAY_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender20" runat="server" TargetControlID="txtTHA_NGAY" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender20" runat="server" TargetControlID="txtTHA_NGAY" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                        
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Địa điểm THA<span class="batbuoc">*</span></td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtTHA_DIADIEM" CssClass="user" runat="server"
                                                Width="532px"></asp:TextBox>

                                        </td>
                                    </tr>
                                    <tr>
                                       
                                        <td style="width: 110px;">Ghi chú THA</td>
                                        <td style="width: 642px" colspan="5">
                                            <asp:TextBox ID="txtTHA_GHICHU" CssClass="user" runat="server" Width="532px"></asp:TextBox>
                                        </td>
                                    </tr>

                                    
                                    <tr>
                                        <td></td>
                                        <td colspan="5">
                                            <asp:Button ID="cmdUpdate_KQTHA" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdate_KQTHA_Click" OnClientClick="return validate_kqtha();" />
                                            <asp:Button ID="cmdDelete_kqtha" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdDelete_kqtha_Click" OnClientClick="return delete_kqtha();"/>
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label6" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                       
                    </asp:Panel>  
                    <!-------------------------------------------------->
                    <!-------------------------------------------------->
             
                    <asp:Panel ID="pnLuuHS" runat="server">
                        <div style="float: left; margin-bottom: 10px; width: 100%; position: relative;">
                            <h4 class="tleboxchung">Thông tin Lưu hồ sơ án tử hình</h4>
                            <div class="boder" style="padding: 1%; width: 96%;">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 110px;">Tình trạng HS<span class="batbuoc">*</span></td>
                                        <td style="width: 210px;" colspan="5">
                                             <asp:DropDownList ID="ddlLUUHS_TINHTRANGHS" CssClass="chosen-select" runat="server" Width="210px">
                                               <asp:ListItem Value="0" Text="--Chọn---" Selected="True"></asp:ListItem>
                                               <asp:ListItem Value="1" Text="Đầy đủ bút lục"></asp:ListItem>
                                               <asp:ListItem Value="2" Text="Thiếu bút lục"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 110px;">Người chuyển HS<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;">
                                            <asp:DropDownList ID="ddlLUUHS_NGUOICHUYEN_ID" CssClass="chosen-select" runat="server" Width="210px">
                                                    </asp:DropDownList>
                                         </td>
                                        <td style="width: 110px;">Ngày chuyển HS<span class="batbuoc">*</span></td>
                                        <td style="width: 200px;"  colspan="3">
                                            <asp:TextBox ID="txtLUUHS_NGAYCHUYEN" CssClass="user" runat="server"
                                                Width="200px" AutoPostBack="true" OnTextChanged="txtLUUHS_NGAYCHUYEN_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender13" runat="server" TargetControlID="txtLUUHS_NGAYCHUYEN" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender13" runat="server" TargetControlID="txtLUUHS_NGAYCHUYEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />

                                        </td>
                                     </tr>
                                    <tr>
                                        <td style="width: 110px;">Người nhận HS </td>
                                        <td style="width: 200px;">
                                            <asp:TextBox ID="txtLUUHS_NGUOINHAN" CssClass="user" runat="server" Width="200px"></asp:TextBox>
                                        </td>
                                                                                
                                        <td style="width: 110px;">Đơn vị nhận </td>
                                        <td style="width: 200px;"  colspan="3">
                                            <asp:TextBox ID="txtLUUHS_DONVINHAN" CssClass="user" runat="server" Width="200px" Text="Phòng Hồ sơ"></asp:TextBox>
                                        </td>
                                    </tr>

                                    
                                    <tr>
                                                                              
                                        <td style="width: 110px;">Ghi chú</td>
                                        <td style="width: 642px;" colspan="5">
                                            <asp:TextBox ID="txtLUUHS_GHICHU" CssClass="user" runat="server" Width="532"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td colspan="3">
                                            <asp:Button ID="cmdUpdateLUUHS" runat="server" CssClass="buttoninput"
                                                Text="Lưu" OnClick="cmdUpdateLUUHS_Click" OnClientClick="return validate_luuHS();" />
                                            <asp:Button ID="cmdDELETE_LUUHS" runat="server" CssClass="buttoninput"
                                                Text="Xóa" OnClick="cmdDELETE_LUUHS_Click"  OnClientClick="return validate_Delete_luuHS();" />
                                        </td>   
                                    </tr>
                                </table>
                                <div style="margin: 5px; width: 95%; color: red;">
                                    <asp:Label ID="Label7" runat="server"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>  
                    <!-------------------------------------------------->
                </div>
                <div style="margin: 5px; text-align: center; width: 95%">
                    <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                </div>

            </div>
        </div>
    </div>

    <script>


        
        function delete_qd_ca() {
            var cmdDelete_CA = document.getElementById('<%=cmdDelete_CA.ClientID%>');
            if (cmdDelete_CA.value == "Xóa") {
                 var result = confirm("Bạn muốn xóa Kết luận của Chánh án?");
                 if (result) {
                     return true;
                 }
                 return false;
             }
             return true;
         }

        function delete_qd_vks() {
            var cmdXoa_VKS = document.getElementById('<%=cmdXoa_VKS.ClientID%>');
            if (cmdXoa_VKS.value == "Xóa") {
                var result = confirm("Bạn muốn xóa Kết luận của Viện kiểm sát?");
                if (result) {
                    return true;
                }
                return false;
            }
            return true;
        }
        
        function delete_qd_ctn() {
            var cmdXoa_CTN = document.getElementById('<%=cmdXoa_CTN.ClientID%>');
            if (cmdXoa_CTN.value == "Xóa") {
                var result = confirm("Bạn muốn xóa Kết luận của Văn phòng CTN?");
                if (result) {
                    return true;
                }
                return false;
            }
            return true;
        }
        function delete_cvxm() {
            var cmdDeleteCVXM = document.getElementById('<%=cmdDeleteCVXM.ClientID%>');
            if (cmdDeleteCVXM.value == "Xóa") {
                var result = confirm("Bạn muốn xóa Công văn xác minh?");
                if (result) {
                    return true;
                }
                return false;
            }
            return true;
        }
        function delete_kqxm() {
            var cmdDelete_KQXM = document.getElementById('<%=cmdDelete_KQXM.ClientID%>');
            if (cmdDelete_KQXM.value == "Xóa") {
                 var result = confirm("Bạn muốn xóa kết quả xác minh?");
                 if (result) {
                     return true;
                 }
                 return false;
             }
             return true;
         }
       
        //--------------Xóa 

        function delete_kqtha() {
            var cmdDelete_kqtha = document.getElementById('<%=cmdDelete_kqtha.ClientID%>');
            if (cmdDelete_kqtha.value == "Xóa") {
                var result = confirm("Bạn muốn xóa Kết quả Công văn THA?");
                if (result) {
                    return true;
                }
                return false;
            }
            return true;
        }
        function validate_Delete_luuHS() {
            var cmdDELETE_LUUHS = document.getElementById('<%=cmdDELETE_LUUHS.ClientID%>');
            if (cmdDELETE_LUUHS.value == "Xóa") {
                var result = confirm("Want to delete?");
                if (result) {
                    return true;
                }
                return false;

            }
            return true;
        }

            //-----------------------------
        function validate_qd_ca() {
        
            var value_change = "";
            //-----------------------------
            var ddlKETLUAN_CA = document.getElementById('<%=ddlKETLUAN_CA.ClientID%>');
            value_change = ddlKETLUAN_CA.options[ddlKETLUAN_CA.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Kết luận của Chánh án!");
                ddlKETLUAN_CA.focus();
                return false;
            }

            //------------------
            var txtSOQD_CA = document.getElementById('<%=txtSOQD_CA.ClientID%>');
            if (!Common_CheckTextBox(txtSOQD_CA, 'Số QD CA'))
                return false;

            //-----------------------------
            var txtNgayQD_CA = document.getElementById('<%=txtNgayQD_CA.ClientID%>'); 
            if (!CheckDateTimeControl(txtNgayQD_CA, "Ngày QD CA"))
                return false;
            //-----------------------------
           
            //-----------------------------
            var txtNGAYPHCV_VKS = document.getElementById('<%=txtNGAYPHCV_VKS.ClientID%>');
            if (!CheckDateTimeControl(txtNGAYPHCV_VKS, "Ngày Phát hành CV gửi VKS"))
                return false;

            //-----------------------------    
            return true;
        }
        

        function validate_qd_vks() {
            var value_change = "";
            //-----------------------------
            var ddlKETLUAN_VKS = document.getElementById('<%=ddlKETLUAN_VKS.ClientID%>');
            value_change = ddlKETLUAN_VKS.options[ddlKETLUAN_VKS.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Kết luận của Viện kiểm sát!");
                ddlKETLUAN_VKS.focus();
                return false;
            }

            //------------------
            var txtSOQD_VKS = document.getElementById('<%=txtSOQD_VKS.ClientID%>');
            if (!Common_CheckTextBox(txtSOQD_VKS, 'Số QD VKS'))
                return false;
            //-----------------------------
            var txtNGAYQD_VKS = document.getElementById('<%=txtNGAYQD_VKS.ClientID%>');
            if (!CheckDateTimeControl(txtNGAYQD_VKS, "Ngày QD VKS"))
                return false;

            //-----------------------------
            var txtSOTT_VKS = document.getElementById('<%=txtSoTT_VKS.ClientID%>');
            if (!Common_CheckTextBox(txtSOTT_VKS, "Số Tờ trình của VKS"))
                return false;
            //-----------------------------
            var txtNGAYTRAHS_VKS = document.getElementById('<%=txtNGAYTT_VKS.ClientID%>');
            if (!CheckDateTimeControl(txtNGAYTRAHS_VKS, "Ngày VKS trả lời"))
                return false;
            //-----------------------------
            var ddlNoidungTT_VKS = document.getElementById('<%=ddlNoidungTT_VKS.ClientID%>');
            value_change = ddlNoidungTT_VKS.options[ddlNoidungTT_VKS.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Nội dung tờ trình của VKS!");
                ddlThamtravien.focus();
                return false;
            }

            //-----------------------------
            return true;
        }
        function validate_qd_ctn() {

            var txtCTN_SOQĐ = document.getElementById('<%=txtCTN_SOQĐ.ClientID%>');
            if (!Common_CheckTextBox(txtCTN_SOQĐ, "So QĐ của Chủ tịch nước"))
                return false;
            //-----------------------------
            var txtCTN_NGAYQD = document.getElementById('<%=txtCTN_NGAYQD.ClientID%>');
            if (!CheckDateTimeControl(txtCTN_NGAYQD, "Ngày QĐ của Chủ tịch nước"))
                return false;
            //-----------------------------
            var txtCTN_NGAYTRA = document.getElementById('<%=txtCTN_NGAYTRA.ClientID%>');
            if (!CheckDateTimeControl(txtCTN_NGAYTRA, "Ngày Chủ tịch nước trả kết quả"))
                return false;
            //-----------------------------
            return true;
        }

        function validate_cvxm() {
         
            //-----------------------------
            var txtSOCVXM = document.getElementById('<%=txtSOCVXM.ClientID%>');
            if (!Common_CheckTextBox(txtSOCVXM, "Số Công văn xác minh"))
                return false;
            //-----------------------------
            var txtNGAYCVXM = document.getElementById('<%=txtNGAYCVXM.ClientID%>');
            if (!CheckDateTimeControl(txtNGAYCVXM, "Ngày QĐ của Chủ tịch nước"))
                return false;
         
            return true;
        }

        function validate_kqxm() {

            var ddlLoaiKQXM = document.getElementById('<%=ddlLoaiKQXM.ClientID%>');
            value_change = ddlLoaiKQXM.options[ddlLoaiKQXM.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Loại kết quả xác minh!");
                ddlLoaiKQXM.focus();
                return false;
            }
            //-----------------------------
            var txtNgayKQXM = document.getElementById('<%=txtNgayKQXM.ClientID%>');
            if (!CheckDateTimeControl(txtNgayKQXM, "Ngày có kết quả xác minh"))
                return false;
            return true;
        }
        //--------------------------------------
      
        //--------------------------------------
        function validate_kqtha() {
            //-----------------------------
            var ddlTHA_KETQUA = document.getElementById('<%=ddlTHA_KETQUA.ClientID%>');
            value_change = ddlTHA_KETQUA.options[ddlTHA_KETQUA.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Kết quả Thi hành án!");
                ddlTHA_KETQUA.focus();
                return false;
            }
            //-----------------------------
            var txtTHA_NGAY = document.getElementById('<%=txtTHA_NGAY.ClientID%>');
            if (!Common_CheckTextBox(txtTHA_NGAY, "Ngày Thi hành án"))
                return false;
            //-----------------------------
            var txtTHA_DIADIEM = document.getElementById('<%=txtTHA_DIADIEM.ClientID%>');
            if (!Common_CheckTextBox(txtTHA_DIADIEM, "Địa điểm Thi hành án"))
                return false;
             return true;
        }
        //--------------------------------------
        function validate_luuHS() {

            //-----------------------------
            var ddlLUUHS_NGUOICHUYEN_ID = document.getElementById('<%=ddlLUUHS_NGUOICHUYEN_ID.ClientID%>');
            value_change = ddlLUUHS_NGUOICHUYEN_ID.options[ddlLUUHS_NGUOICHUYEN_ID.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn Người chuyển hồ sơ!");
                ddlLUUHS_NGUOICHUYEN_ID.focus();
                return false;
            }

            //-----------------------------
            var txtLUUHS_NGAYCHUYEN = document.getElementById('<%=txtLUUHS_NGAYCHUYEN.ClientID%>');
            if (!Common_CheckTextBox(txtLUUHS_NGAYCHUYEN, "Ngay chuyển lưu Hồ sơ"))
                return false;
            //-----------------------------
                   
            var ddlLUUHS_TINHTRANGHS = document.getElementById('<%=ddlLUUHS_TINHTRANGHS.ClientID%>');
            value_change = ddlLUUHS_TINHTRANGHS.options[ddlLUUHS_TINHTRANGHS.selectedIndex].value;
            if (value_change == "0") {
                alert("Bạn chưa chọn tình trạng hồ sơ!");
                ddlLUUHS_TINHTRANGHS.focus();
                return false;
            }

            //-----------------------------
            return true;
        }


       
       
        </script>

     <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
              
    </script>
</asp:Content>
