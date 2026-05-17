<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DanhsachBiCan.aspx.cs" Inherits="WEB.GSTP.QLAN.THA.HoSo.DanhsachBiCan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin bị can</title>

    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>

    <script src="../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }



        .box {
            height: 550px;
            overflow: auto;
            position: absolute;
            top: 65px;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .align_right {
            text-align: right;
        }

        .link_save {
            margin-left: 0px;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddIsReloadParent" Value="0" runat="server" />
                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />

                <asp:HiddenField ID="hddID" runat="server" Value="0" />
                <asp:HiddenField ID="hddBiCanDauVuID" runat="server" Value="0" />
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <asp:HiddenField ID="hddShowCommand" Value="True" runat="server" />
                <div id="zone_message"></div>
                <!----------------------------------------->
                <div style="margin: 5px; text-align: center; width: 95%; position: absolute; top: 10px;">
                    <asp:Button ID="cmdUpdate2" runat="server" CssClass="buttoninput"
                        Text="Lưu và thoát" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNext2" runat="server" CssClass="buttoninput"
                        Text="Lưu và nhập tiếp" OnClick="cmdUpdateAndNext_Click" OnClientClick="return validate();" />
                    <input type="button" class="buttoninput" onclick="ClosePopup()" value="Thoát" />
                    <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                        <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                    </div>
                </div>
                <div style="display: none">
                    <asp:Button ID="cmdLoadDsToiDanh" runat="server"
                        Text="Load ds toidanh" OnClick="cmdLoadDsToiDanh_Click" />
                </div>
                <div class="box">


                    <div class="box_nd">
                        <div class="boxchung">
                            <h4 class="tleboxchung">1. Thông tin bị can</h4>
                            <div class="boder">
                                <table class="table1">
                                    <tr>
                                        <td style="width: 115px;">Đối tượng phạm tội</td>
                                        <td style="width: 250px;">

                                            <asp:DropDownList ID="dropDoiTuongPhamToi"
                                                CssClass="chosen-select" runat="server" Width="250">
                                                <asp:ListItem Value="0" Text="Cá nhân"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="Pháp nhân thương mại"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Pháp nhân phi thương mại"></asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td style="width: 110px;">Bị can đầu vụ</td>
                                        <td>
                                            <asp:RadioButtonList ID="rdBiCanDauVu" runat="server"
                                                RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>
                                    <tr>
                                        <td>Tên bị can<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:TextBox ID="txtTen" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                        </td>
                                        <td>Ngày sinh</td>
                                        <td>
                                            <asp:TextBox ID="txtNgaysinh" runat="server" CssClass="user" Width="100px"
                                                onkeypress="return isNumber(event)"
                                                AutoPostBack="true" OnTextChanged="txtNgaysinh_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtNgaysinh" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtNgaysinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            Năm sinh <span class="batbuoc">(*)</span>
                                            <asp:TextBox ID="txtNamSinh" runat="server" CssClass="user align_right"
                                                AutoPostBack="true" OnTextChanged="txtNamSinh_TextChanged"
                                                onkeypress="return isNumber(event)"
                                                Width="52px" MaxLength="4"></asp:TextBox>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Tên khác</td>
                                        <td>
                                            <asp:TextBox ID="txtTenKhac" CssClass="user"
                                                runat="server" Width="242px"></asp:TextBox>
                                        </td>
                                        <td>CMND/Thẻ căn cước/Hộ chiếu</td>
                                        <td>
                                            <asp:TextBox ID="txtCMND" CssClass="user"
                                                runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>

                                    </tr>
                                    <tr>
                                        <td>Giới tính</td>
                                        <td>
                                            <asp:DropDownList ID="ddlGioitinh" CssClass="chosen-select" runat="server"
                                                Width="250px">
                                                <asp:ListItem Value="1" Text="Nam"></asp:ListItem>
                                                <asp:ListItem Value="0" Text="Nữ"></asp:ListItem>
                                            </asp:DropDownList></td>

                                        <td>Quốc tịch<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="dropQuocTich" CssClass="chosen-select"
                                                runat="server" Width="250px" AutoPostBack="True" OnSelectedIndexChanged="dropQuocTich_SelectedIndexChanged">
                                            </asp:DropDownList></td>
                                    </tr>

                                    <asp:Panel ID="pnHoKhau" runat="server">
                                        <tr>
                                            <td>Nơi sinh<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="ddlHKTT_Tinh" CssClass="chosen-select" runat="server"
                                                    Width="120px"
                                                    AutoPostBack="true"
                                                    OnSelectedIndexChanged="ddlHKTT_Tinh_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <div style="float: right;">
                                                    <asp:DropDownList ID="ddlHKTT_Huyen" CssClass="chosen-select float_right"
                                                        runat="server" Width="120px">
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td>Địa chỉ chi tiết</td>
                                            <td>
                                                <asp:TextBox ID="txtHKTT_Chitiet" CssClass="user"
                                                    runat="server" Width="242px" MaxLength="250"></asp:TextBox></td>
                                        </tr>
                                    </asp:Panel>
                                    <tr>
                                        <td>Nơi cư trú<span id="zoneTamtru"></span></td>
                                        <td>
                                            <asp:DropDownList ID="ddlTamTru_Tinh" CssClass="chosen-select" runat="server"
                                                Width="120px"
                                                AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlTamTru_Tinh_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <div style="float: right;">
                                                <asp:DropDownList ID="ddlTamTru_Huyen" CssClass="chosen-select"
                                                    runat="server" Width="120px">
                                                </asp:DropDownList>
                                            </div>
                                        </td>
                                        <td>Địa chỉ chi tiết</td>
                                        <td>
                                            <asp:TextBox ID="txtTamtru_Chitiet" CssClass="user"
                                                runat="server" Width="242px" MaxLength="250"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>Ngày bị khởi tố</td>
                                        <td>
                                            <asp:TextBox ID="txtNgayKhoiTo" runat="server" CssClass="user"
                                                Width="112px" MaxLength="10" onkeypress="return isNumber(event)"
                                                AutoPostBack="true" OnTextChanged="txtNgayKhoiTo_TextChanged"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNgayKhoiTo" Format="dd/MM/yyyy" Enabled="true" />
                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayKhoiTo" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </td>
                                        <td>Dân tộc</td>
                                        <td>
                                            <asp:DropDownList ID="dropDanToc" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList></td>

                                    </tr>
                                    <tr>
                                        <td>Tôn giáo</td>
                                        <td>
                                            <asp:DropDownList ID="dropTonGiao" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                        <td>Nghề nghiệp</td>
                                        <td>
                                            <asp:DropDownList ID="dropNgheNghiep" CssClass="chosen-select" runat="server" Width="250">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td>Trình độ văn hóa<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:DropDownList ID="dropTrinhDoVH" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                        <td>Tình trạng giam giữ</td>
                                        <td>
                                            <asp:DropDownList ID="dropTinhTrangGiamGiu" CssClass="chosen-select"
                                                runat="server" Width="250px">
                                            </asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <td>Chức vụ đảng<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdChucVuDang"
                                                runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                        <td>Công chức, viên chức<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdChuvVuCQ" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                    </tr>
                                    <tr>
                                        <td>Nghiện hút<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdNGhienHut" runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                        <td>Tái phạm, tái phạm nguy hiểm<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTinhTrangTaiPham"
                                                runat="server" RepeatDirection="Horizontal">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Tiền án</td>
                                        <td>
                                            <asp:TextBox ID="txtTienAn" CssClass="user align_right"
                                                onkeypress="return isNumber(event)" runat="server"
                                                Width="242px" MaxLength="50"></asp:TextBox></td>
                                        <td>Tiền sự</td>
                                        <td>
                                            <asp:TextBox ID="txtTienSu" CssClass="user align_right"
                                                onkeypress="return isNumber(event)" runat="server"
                                                Width="242px" MaxLength="50"></asp:TextBox></td>
                                    </tr>
                                    <!---------------------------------------------->
                                    <tr>
                                        <td>Trẻ vị thành niên<span class="batbuoc">(*)</span></td>
                                        <td>
                                            <asp:RadioButtonList ID="rdTreViThanhNien"
                                                runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdTreViThanhNien_SelectedIndexChanged">
                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                            </asp:RadioButtonList></td>
                                        <asp:Panel ID="pnTuoi" runat="server">
                                            <td>Tuổi khi phạm tội<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:TextBox ID="txtTuoi" CssClass="user align_right"
                                                    onkeypress="return isNumber(event)" runat="server"
                                                    Width="242px" MaxLength="2"></asp:TextBox></td>
                                        </asp:Panel>
                                    </tr>

                                    <asp:Panel ID="pnTreViThanhNien" runat="server" Visible="false">

                                        <tr>
                                            <td>Trẻ mồ côi cha hoặc mẹ<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdTreMoCoi" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            <td style="width: 80px;">Trẻ lang thang<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdTreLangThang" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Trẻ bỏ học<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdTreBoHoc" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            <td>Bố mẹ ly hôn<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdLyHon" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Có người đủ 18 tuổi trở lên xúi giục<span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:RadioButtonList ID="rdNguoiXuiGiuc" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                </asp:RadioButtonList></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </asp:Panel>
                                </table>
                            </div>
                        </div>
                        <!-------------------------------------->
                        <asp:Panel ID="pnToiDanh" runat="server">
                            <div class="boxchung">
                                <h4 class="tleboxchung">2. Điều luật áp dụng cho bị can</h4>
                                <div class="boder">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 70px;"><b>Bộ luật</b><span class="batbuoc">(*)</span></td>
                                            <td>
                                                <div style="float: left; margin-right: 5px;">
                                                    <asp:DropDownList ID="dropBoLuat" runat="server" CssClass="chosen-select" Width="315px" Height="31px"
                                                        AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                                <asp:LinkButton ID="lkChoiceToiDanh" runat="server"
                                                    OnClientClick="return validate_bican();" OnClick="lkChoiceToiDanh_Click"
                                                    CssClass="link_choice">Chọn điều luật</asp:LinkButton>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Điểm</b></td>
                                            <td>
                                                <span style="float: left; margin-right: 10PX;">
                                                    <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px"></asp:TextBox>

                                                    <!----------->
                                                    <b style="width: 50px;">Khoản</b><span class="batbuoc">(*)</span>
                                                    <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                                    <!----------->
                                                    <b style="width: 50px;">Điều<span class="batbuoc">(*)</span></b>
                                                    <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                                </span>
                                                <!----------->
                                                <asp:Button ID="cmdThemDieuLuat" runat="server" CssClass="buttonpopup link_save"
                                                    Text="Lưu điều luật" OnClick="cmdThemDieuLuat_Click"
                                                    OnClientClick="return validate_themtoidanh();" Width="128px" />

                                                <asp:Button ID="cmdGetToiDanhDauVu" runat="server"
                                                    CssClass="buttonpopup link_save"
                                                    Text="Áp dụng tội danh của bị can đầu vụ"
                                                    OnClick="cmdGetToiDanhDauVu_Click"
                                                    OnClientClick="return validate_bican();" />


                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="2">
                                                <div>
                                                    <asp:HiddenField ID="hddToiDanh" runat="server" Value="0" />
                                                    <asp:Label runat="server" ID="lbthongbao" ForeColor="Red"></asp:Label>
                                                </div>
                                                <asp:Panel runat="server" ID="pndata" Visible="false">
                                                    <div class="phantrang">
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
                                                    <asp:HiddenField ID="hddOld" runat="server" Value="" />
                                                    <asp:Repeater ID="rpt" runat="server"
                                                        OnItemDataBound="rpt_ItemDataBound" OnItemCommand="rpt_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table2" width="100%" border="1">
                                                                <tr class="header">
                                                                    <td width="42">
                                                                        <div align="center"><strong>STT</strong></div>
                                                                    </td>
                                                                    <td width="150px">
                                                                        <div align="center"><strong>Bộ luật</strong></div>
                                                                    </td>
                                                                    <td width="50px">
                                                                        <div align="center"><strong>Điều</strong></div>
                                                                    </td>
                                                                    <td width="50px">
                                                                        <div align="center"><strong>Khoản</strong></div>
                                                                    </td>

                                                                    <td width="50px">
                                                                        <div align="center"><strong>Điểm</strong></div>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center"><strong>Tội danh</strong></div>
                                                                    </td>
                                                                    <td width="60px">
                                                                        <div align="center"><strong>Thao tác</strong></div>
                                                                    </td>
                                                                </tr>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td>
                                                                    <div style="float: left; width: 100%; text-align: center;">
                                                                        <%#Eval("STT") %>
                                                                    </div>
                                                                </td>
                                                                <td><%# Eval("TenBoLuat") %></td>
                                                                <td><%# Eval("Dieu") %></td>
                                                                <td><%# Eval("Khoan") %></td>

                                                                <td><%# Eval("Diem") %></td>
                                                                <td>
                                                                    <asp:HiddenField ID="hddArrSapXep" runat="server" Value='<%#Eval("ArrSapXep") %>' />
                                                                    <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("Loai") %>' />
                                                                    <asp:HiddenField ID="hddToiDanhID" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                                                    <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID") %>' />
                                                                    <asp:HiddenField ID="hddLoaiToiPham" runat="server" Value='<%#Eval("LoaiToiPham") %>' />

                                                                    <asp:Literal ID="lttChiTiet" runat="server"></asp:Literal>

                                                                    <asp:TextBox ID="txtTenToiDanh" CssClass="user" Width="98%"
                                                                        Font-Bold="true" runat="server" Text='<%#Eval("TENTOIDANH") %>'
                                                                        Visible='<%# Convert.ToInt16( Eval("IsEdit")+"")==1?true:false  %>'></asp:TextBox>
                                                                    <div style='display: <%# Convert.ToInt16( Eval("IsEdit")+"")==1? "none":"block"  %>'>
                                                                        <%#Eval("TENTOIDANH") %>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:LinkButton ID="lkXoa" runat="server" Text="Xóa"
                                                                            OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"
                                                                            CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="xoa"></asp:LinkButton>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate></table></FooterTemplate>
                                                    </asp:Repeater>

                                                    <div class="phantrang">
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
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </asp:Panel>

                    </div>
                    <div style="float: left; width: 100%; margin-bottom: 100px;">
                        <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                            <asp:Literal ID="lstMsgB" runat="server"></asp:Literal>
                        </div>

                    </div>
                </div>
                <div style="display: none; margin: 5px; text-align: center; width: 95%; float: left; position: absolute; bottom: 10px; margin-bottom: 100px;">
                    <asp:Button ID="cmdUpdate" runat="server" CssClass="buttoninput"
                        Text="Lưu và thoát" OnClick="cmdUpdate_Click" OnClientClick="return validate();" />
                    <asp:Button ID="cmdUpdateAndNext" runat="server" CssClass="buttoninput"
                        Text="Lưu và nhập tiếp" OnClick="cmdUpdateAndNext_Click" OnClientClick="return validate();" />
                    <input type="button" class="buttoninput" onclick="window.close();" value="Thoát" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
    <script>
        function PopupCenter(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function popupChonToiDanh(VuAnID ,BiCaoID) {
            if (!validate_bican())
                return false;
            else {
                //-----------------------
                var width = 950;
                var height = 750;
                var link = "/QLAN/THA/HoSo/ChonToiDanh.aspx?hsID=" + VuAnID +"&bID=" + BiCaoID;
                PopupCenter(link, "Cập nhật quyết định và hình phạt", width, height);
            }
            return true;
        }

        function popup_edit_nhanthan(VuAnID, BiCanID) {
            var link = "";
            link = "/QLAN/AHS/Hoso/popup/pNhanThan.aspx?type=CON&hsID=" + VuAnID + "&bID=" + BiCanID;
            var width = 650;
            var height = 450;
            PopupCenter(link, "Cập nhật thông tin nhân thân của bị can", width, height);
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
    </script>

    <script>
        function validate() {
            if (!validate_bican())
                return false;

            if (!validate_nhanthan())
                return false;

            if (!validate_bienphapnc())
                return false;
            //alert(1);
            return true;
        }

        function validate_bican() {
            var msg = "";
            var txtTen = document.getElementById('<%=txtTen.ClientID%>');
            if (!Common_CheckEmpty(txtTen.value)) {
                alert('Bạn chưa nhập tên bị can. Hãy kiểm tra lại!');
                txtTen.focus();
                return false;
            }
            //------------------------------
            var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');
            var txtNgayKhoiTo = document.getElementById('<%=txtNgayKhoiTo.ClientID%>');
            if (Common_CheckEmpty(txtNgaysinh.value)) {
                var ngaysinh = txtNgaysinh.value;
                if (!CheckDateTimeControl(txtNgaysinh, 'Ngày sinh của bị can'))
                    return false;
                //-------------------------------
                if (!SoSanh2Date(txtNgayKhoiTo, "Ngày bị khởi tố", txtNgaysinh.value, "Ngày sinh của bị can"))
                    return false;
            }
            var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
            if (!Common_CheckEmpty(txtNamSinh.value)) {
                alert('Bạn chưa nhập năm sinh của bị can. Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }
            var CurrentYear = '<%=CurrentYear%>';
            var namsinh = parseInt(txtNamSinh.value);
            if (namsinh > CurrentYear) {
                alert('Năm sinh phải nhỏ hơn hoặc bằng năm hiện tại. Hãy kiểm tra lại!');
                txtNamSinh.focus();
                return false;
            }

            //-----------------------------
            if (!validate_quoctich())
                return false;
            //-------------------------
            //Bỏ bắt buộc nhập "Ngày khởi tố"
            <%--var txtNgayKhoiTo = document.getElementById('<%=txtNgayKhoiTo.ClientID%>');
            if (!CheckDateTimeControl(txtNgayKhoiTo, 'Ngày bị khởi tố'))
                return false;--%>
            //-----------------------------
            var dropDanToc = document.getElementById('<%=dropDanToc.ClientID%>');
            value_change = dropDanToc.options[dropDanToc.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "Dân tộc". Hãy kiểm tra lại!');
                dropDanToc.focus();
                return false;
            }
            //-------------------------------------------------
            var rdChucVuDang = document.getElementById('<%=rdChucVuDang.ClientID%>');
            msg = 'Mục "Chức vụ Đảng" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdChucVuDang, msg))
                return false;
            //----------------------------
            var rdChuvVuCQ = document.getElementById('<%=rdChuvVuCQ.ClientID%>');
            msg = 'Mục "Công chức, viên chức" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdChuvVuCQ, msg))
                return false;
            //----------------------------
            var dropTrinhDoVH = document.getElementById('<%=dropTrinhDoVH.ClientID%>');
            value_change = dropTrinhDoVH.options[dropTrinhDoVH.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "Trình độ văn hóa". Hãy kiểm tra lại!');
                dropTrinhDoVH.focus();
                return false;
            }
            //----------------------------
            var rdNGhienHut = document.getElementById('<%=rdNGhienHut.ClientID%>');
            msg = 'Mục "Nghiện hút" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdNGhienHut, msg))
                return false;
            //----------------------------
            var rdTinhTrangTaiPham = document.getElementById('<%=rdTinhTrangTaiPham.ClientID%>');
            msg = 'Mục "Tái phạm, tái phạm nguy hiểm" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTinhTrangTaiPham, msg))
                return false;
            //----------------------------
            var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
            msg = 'Mục "Trẻ vị thành niên" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreViThanhNien, msg))
                return false;
            else {
                var selected_value = GetStatusRadioButtonList(rdTreViThanhNien);
                if (selected_value == 1) {
                    if (!validate_trevithanhnien())
                        return false;
                }
            }
            var txtTuoi = document.getElementById('<%=txtTuoi.ClientID%>');
            if (!Common_CheckEmpty(txtTuoi.value)) {
                alert('Bạn chưa nhập tuổi khi phạm tội của bị can. Hãy kiểm tra lại!');
                txtTuoi.focus();
                return false;
            }
            var tuoikhiphamtoi = parseInt(txtTuoi.value);
            if (tuoikhiphamtoi > (CurrentYear - namsinh)) {
                alert('Tuổi khi phạm tội hoặc năm sinh nhập sai. Hãy kiểm tra lại!');
                txtTuoi.focus();
                return false;
            }

            return true;
        }
        function validate_trevithanhnien() {
            var txtTuoi = document.getElementById('<%=txtTuoi.ClientID%>');
            if (!Common_CheckEmpty(txtTuoi.value)) {
                alert('Bạn chưa nhập Tuổi phạm tội của bị can vị thành niên. Hãy kiểm tra lại!');
                txtTuoi.focus();
                return false;
            }
            //-------------------------
            var rdTreMoCoi = document.getElementById('<%=rdTreMoCoi.ClientID%>');
            msg = 'Mục "Trẻ mồ côi cha hoặc mẹ" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreMoCoi, msg))
                return false;
            //----------------------------
            //msg = 'Mục "" bắt buộc phải chọn.';
            var rdTreLangThang = document.getElementById('<%=rdTreLangThang.ClientID%>');
            msg = 'Mục "Trẻ lang thang" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreLangThang, msg))
                return false;
            //----------------------------
            var rdTreBoHoc = document.getElementById('<%=rdTreBoHoc.ClientID%>');
            msg = 'Mục "Trẻ bỏ học" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdTreBoHoc, msg))
                return false;

            //----------------------------
            var rdLyHon = document.getElementById('<%=rdLyHon.ClientID%>');
            msg = 'Mục "Bố mẹ ly hôn" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdLyHon, msg))
                return false;

            //----------------------------
            var rdNguoiXuiGiuc = document.getElementById('<%=rdNguoiXuiGiuc.ClientID%>');
            msg = 'Mục "Có người đủ 18 tuổi trở lên xúi giục" bắt buộc phải chọn. Hãy kiểm tra lại!';
            if (!CheckChangeRadioButtonList(rdNguoiXuiGiuc, msg))
                return false;

            return true;
        }
        function validate_quoctich() {
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            var value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;
            if (value_change == "") {
                alert('Bạn chưa chọn mục "quốc tịch". Hãy kiểm tra lại!');
                dropQuocTich.focus();
                return false;
            }
            //-----------------------------------------
            var QuocTichVN = '<%=QuocTichVN%>';
            var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
            value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;

            if (value_change == QuocTichVN) {
                document.getElementById('zoneTamtru').innerHTML = "<span class='batbuoc'>(*)</span>";

                //--------check nhap ho khau thuong tru---------
                var ddlHKTT_Tinh = document.getElementById('<%=ddlHKTT_Tinh.ClientID%>');
                var ddlHKTT_Huyen = document.getElementById('<%=ddlHKTT_Huyen.ClientID%>');

                value_change = ddlHKTT_Tinh.options[ddlHKTT_Tinh.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn mục "Tỉnh/TP của Nơi sinh". Hãy kiểm tra lại!');
                    ddlHKTT_Tinh.focus();
                    return false;
                }
                //value_change = ddlHKTT_Huyen.options[ddlHKTT_Huyen.selectedIndex].value;
                //if (value_change == "0") {
                //    alert('Bạn chưa chọn mục "Quận/Huyện của hộ khẩu thường trú". Hãy kiểm tra lại!');
                //    ddlHKTT_Huyen.focus();
                //    return false;
                //}

                //--------check nhap ho khau tam tru---------
                var ddlTamTru_Tinh = document.getElementById('<%=ddlTamTru_Tinh.ClientID%>');
                var ddlTamTru_Huyen = document.getElementById('<%=ddlTamTru_Huyen.ClientID%>');
                value_change = ddlTamTru_Tinh.options[ddlTamTru_Tinh.selectedIndex].value;
                if (value_change == "0") {
                    alert('Bạn chưa chọn mục "Nơi cư trú". Hãy kiểm tra lại!');
                    ddlTamTru_Tinh.focus();
                    return false;
                }
                //value_change = ddlTamTru_Huyen.options[ddlTamTru_Huyen.selectedIndex].value;
                //if (value_change == "0") {
                //    alert('Bạn chưa chọn mục "Quận/Huyện của nơi Tạm trú". Hãy kiểm tra lại!');
                //    ddlTamTru_Huyen.focus();
                //    return false;
                //}
            }
            else
                document.getElementById('zoneTamtru').innerHTML = "";
            return true;
        }
        var QuocTichVN = '<%=QuocTichVN%>';
        var dropQuocTich = document.getElementById('<%=dropQuocTich.ClientID%>');
        value_change = dropQuocTich.options[dropQuocTich.selectedIndex].value;

        if (value_change == QuocTichVN) {
            document.getElementById('zoneTamtru').innerHTML = "<span class='batbuoc'>(*)</span>";
        }
        else {
            document.getElementById('zoneTamtru').innerHTML = "";
        }
        function validate_themtoidanh() {
            if (!validate_bican())
                return false;
            if (!validate_bienphapnc())
                return false;
            var dropBoLuat = document.getElementById('<%=dropBoLuat.ClientID%>');
            value_change = dropBoLuat.options[dropBoLuat.selectedIndex].value;
            if (value_change == "0") {
                alert('Bạn chưa chọn bộ luật. Hãy kiểm tra lại!');
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
        function validate_rd_vithanhnien() {
            var CurrentYear = '<%=CurrentYear%>';
            var rdTreViThanhNien = document.getElementById('<%=rdTreViThanhNien.ClientID%>');
            var txtNgayKhoiTo = document.getElementById('<%=txtNgayKhoiTo.ClientID%>');

            var selected_value = GetStatusRadioButtonList(rdTreViThanhNien);
            if (selected_value == 1) {
                if (!CheckDateTimeControl(txtNgayKhoiTo, 'Ngày bị khởi tố của bị can'))
                    return false;
                var txtNgaysinh = document.getElementById('<%=txtNgaysinh.ClientID%>');
                if (Common_CheckEmpty(txtNgaysinh.value)) {
                    if (!CheckDateTimeControl(txtNgaysinh, 'Ngày sinh của bị can'))
                        return false;
                }
                var txtNamSinh = document.getElementById('<%=txtNamSinh.ClientID%>');
                if (!Common_CheckEmpty(txtNamSinh.value)) {
                    alert('Bạn chưa nhập năm sinh của bị can. Hãy kiểm tra lại!');
                    txtNamSinh.focus();
                    return false;
                }
                else {
                    var namsinh = parseInt(txtNamSinh_NT.value);
                    if (namsinh > CurrentYear) {
                        alert('Năm sinh phải nhỏ hơn hoặc bằng năm hiện tại. Hãy kiểm tra lại!');
                        txtNamSinh.focus();
                        return false;
                    }
                }
            }
            return true;
        }
    </script>
    <script>
        function ClosePopup() {
            var hddIsReloadParent = document.getElementById('<%=hddIsReloadParent.ClientID%>');
            var value = parseInt(hddIsReloadParent.value);
            if (value == 0)
                window.close();
            else
                ReloadParent();
        }
        function ReloadParent() {
            window.onunload = function (e) {
                opener.LoadDsBiCan();
            };
            window.close();
        }
        function LoadDsToiDanh() {
            $("#<%= cmdLoadDsToiDanh.ClientID %>").click();
        }
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
    <script type = "text/javascript">
        function OnClose() {

            if (window.opener != null && !window.opener.closed) {

                window.opener.HideModalDiv();

            }

        }

        window.onunload = OnClose;

    </script>
</body>
</html>

