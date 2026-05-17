<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Capnhatdanhgia.aspx.cs" Inherits="WEB.GSTP.GSTP.Capnhatdanhgia" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .lbTitle_DonCap {
            float: left;
            width: 12%;
            margin-bottom: 3px;
            font-weight: bold;
        }

        .inputData_DonCap {
            float: left;
            width: 88%;
            margin-bottom: 8px;
        }

        .clear {
            clear: both;
        }

        .DataInfo {
            margin-left: 5px;
            margin-top: 10px;
            width: 99%;
            float: left;
        }
    </style>
    <div class="box" style="float: left; width: 99%;">
        <div class="box_nd" style="float: left; width: 99%;">
            <div class="truong" style="float: left; width: 99%;">

                <div class="DataInfo">
                    <div class="lbTitle_DonCap">Tên vụ án bị hủy:</div>
                    <div class="inputData_DonCap">
                        <asp:Label ID="lblTenVuAn" runat="server"></asp:Label>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap">Tòa án xét xử:</div>
                    <div class="inputData_DonCap">
                        <asp:Label ID="lblTenToaAn" runat="server"></asp:Label>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap">Thẩm phán:</div>
                    <div class="inputData_DonCap">
                        <asp:Label ID="lblThamPhan" runat="server"></asp:Label>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap">Vai trò:</div>
                    <div class="inputData_DonCap">
                        <asp:Label ID="lblVaiTro" runat="server"></asp:Label>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap" style="margin-top: 6px;">Tự đánh giá:</div>
                    <div class="inputData_DonCap">
                        <asp:RadioButtonList ID="rdbTuDanhGia" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="0" Text="Chủ quan"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Khách quan" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap">Lý do:</div>
                    <div class="inputData_DonCap">
                        <asp:TextBox ID="txtLyDoTuDG" runat="server" Width="99%" CssClass="user"></asp:TextBox>
                    </div>
                    <div class="ClearBoth"></div>
                    <asp:Panel ID="pnUBHDXX" runat="server">
                        <div class="lbTitle_DonCap">Ủy ban thẩm phán đánh giá:</div>
                        <div class="inputData_DonCap">
                            <asp:RadioButtonList ID="rdbUBDanhGia" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Text="Chủ quan"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Khách quan" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="ClearBoth"></div>

                        <div class="lbTitle_DonCap">Lý do:</div>
                        <div class="inputData_DonCap">
                            <asp:TextBox ID="txtLyDoUBDanhGia" runat="server" Width="99%" CssClass="user"></asp:TextBox>
                        </div>
                        <div class="ClearBoth"></div>
                    </asp:Panel>
                    <div class="lbTitle_DonCap"></div>
                    <div class="inputData_DonCap">
                        <div class="bt" style="float: left; margin-right: 10px;">
                            <asp:Button ID="cmdCapNhat" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return KtratenDV()" OnClick="cmdCapNhat_Click" />
                            <asp:Button ID="cmdLamMoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLamMoi_Click" />
                            <asp:Button ID="cmdQuaylai" runat="server" CssClass="buttoninput" Text="Quay lại" OnClick="cmdQuaylai_Click" />
                        </div>
                        <div style="margin-top: 6px;">
                        </div>
                    </div>
                    <div class="clear"></div>

                    <div class="lbTitle_DonCap"></div>
                    <div class="inputData_DonCap">
                        <asp:Label runat="server" ID="lbthongbao" ForeColor="Red" Text=""></asp:Label>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
