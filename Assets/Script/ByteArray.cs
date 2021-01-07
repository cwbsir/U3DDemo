using System;
using System.IO;
using System.Text;
using UnityEngine;

//编码格式 Endian.BIG_ENDIAN
public class ByteArray
{
    private MemoryStream stream = null;
    private BinaryReader reader = null;
    public ByteArray()
    {
        init();
    }

    public void init()
    {
        reSet();
        stream = new MemoryStream();
        stream.Position = 0;
    }

    public void loadBytes(byte[] data,int startPosition = 0)
    {
        if(data != null && data.Length > 0)
        {
            stream.Write(data, startPosition, data.Length - startPosition);
            stream.Position = 0;
            if(reader == null)
            {
                reader = new BinaryReader(stream);
            }
        }
    }

    public void loadBytesOffset(byte[] data,int offset,int count)
    {
        if (data != null && data.Length > 0)
        {
            if (count > data.Length) count = data.Length;
            stream.Write(data, offset, count);
            stream.Position = 0;
            reader = new BinaryReader(stream);
        }
    }

    public sbyte readByte()
    {
        return reader.ReadSByte();
    }

    public void writeByte(byte b)
    {
        stream.WriteByte(b);
    }

    public bool readBoolean()
    {
        return reader.ReadBoolean();
    }

    public void writeBoolean(bool b)
    {
        byte[] data = BitConverter.GetBytes(b);
        stream.Write(data,0,data.Length);
    }

    public short readShort()
    {
        //byte[] data = reader.ReadBytes(2);
        //Array.Reverse(data);
        //return BitConverter.ToInt16(data,0);
        return reader.ReadInt16();
    }

    public void writeShort(short v)
    {
        //reverseBytes(BitConverter.GetBytes(v));
        byte[] data = BitConverter.GetBytes(v);
        stream.Write(data, 0, data.Length);
    }

    public int readInt()
    {
        //byte[] data = reader.ReadBytes(4);
        //Array.Reverse(data);
        //return BitConverter.ToInt32(data,0);
        return reader.ReadInt32();
    }

    public void writeInt(int v)
    {
        //reverseBytes(BitConverter.GetBytes(v));
        byte[] data = BitConverter.GetBytes(v);
        stream.Write(data, 0, data.Length);
    }
    //lua无法转换 c# long类型 只能用double
    public double readNumber()
    {
        //byte[] data = reader.ReadBytes(8);
        //Array.Reverse(data);
        //return (double)BitConverter.ToInt64(data,0);
        return reader.ReadInt64();
    }

    public void writeNumber(double v)
    {
        //reverseBytes(BitConverter.GetBytes((long)v));
        byte[] data = BitConverter.GetBytes((long)v);
        stream.Write(data, 0, data.Length);
    }

    public string readString()
    {
        short len = readShort();
        byte[] buffer = reader.ReadBytes(len);
        return Encoding.UTF8.GetString(buffer);
    }

    public void writeString(string str)
    {
        if(str != null)
        {
            byte[] data = Encoding.UTF8.GetBytes(str);
            byte[] lenBytes = BitConverter.GetBytes((short)data.Length);
            //reverseBytes(lenBytes);
            stream.Write(lenBytes, 0, lenBytes.Length);
            stream.Write(data, 0, data.Length);
        }
    }

    private void reverseBytes(byte[] bytes)
    {
        if (bytes == null || bytes.Length < 1) return;
        int len = bytes.Length;
        for (int i = len - 1; i >= 0; i--)
        {
            stream.WriteByte(bytes[i]);
        }
    }

    public uint getPosition()
    {
        return (uint)stream.Position;
    }

    public void setPosition(long v)
    {
        stream.Position = v;
    }

    public byte readUByte()
    {
        return reader.ReadByte();
    }

    public ushort readUShort()
    {
        //byte[] data = reader.ReadBytes(2);
        //Array.Reverse(data);
        //return BitConverter.ToUInt16(data, 0);
        return reader.ReadUInt16();
    }

    public uint readUInt()
    {
        //byte[] data = reader.ReadBytes(4);
        //Array.Reverse(data);
        //return BitConverter.ToUInt32(data, 0);
        return reader.ReadUInt32();
    }

    public string readIntString()
    {
        int len = readInt();
        byte[] buffer = reader.ReadBytes(len);
        return Encoding.UTF8.GetString(buffer);
    }

    public long getLength()
    {
        if (stream != null)
        {
            return stream.Length;
        }
        return 0;
    }

    public byte[] getSendBytes()
    {
        return stream.ToArray();
    }

    public void reSet()
    {
        if(stream != null)
        {
            stream.Close();
        }
        if(reader != null)
        {
            reader.Close();
        }
        stream = null;
        reader = null;
    }
}
